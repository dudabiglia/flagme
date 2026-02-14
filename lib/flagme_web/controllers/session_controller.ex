defmodule FlagmeWeb.SessionController do
  @moduledoc """
  In practice, the flow works like this:

  1. User logs in with email/password.
  2. Your server sends back both an access token (short-lived, say 15 minutes) and a refresh token
  (long-lived, say 30 days).
  3. The client sends the access token with every API request.
  4. When the access token expires, the client sends the refresh token to a special endpoint and gets
  a new access token — without the user having to log in again.
  5. If the refresh token expires, the user has to log in again.
  """

  use FlagmeWeb, :controller

  alias Flagme.Guardian
  alias Flagme.Accounts

  action_fallback FlagmeWeb.FallbackController

  def signin(conn, %{"email" => email, "password" => password}) do
    case Accounts.auth_user(email, password) do
      {:ok, user} ->
        perms = Guardian.build_permissions(user.permissions)

        {:ok, access_token, _claims} =
          Guardian.encode_and_sign(user, %{},
            token_type: "access",
            ttl: {15, :minute},
            permissions: perms
          )

        {:ok, refresh_token, _claims} =
          Guardian.encode_and_sign(user, %{},
            token_type: "refresh",
            ttl: {7, :day},
            permissions: perms
          )

        conn
        |> put_resp_cookie("ruid", refresh_token)
        |> put_status(:created)
        |> render(:token, access_token: access_token)

      {:error, :unauthorized} ->
        conn
        |> put_status(401)
        |> json(%{error: "unauthorized"})
    end
  end

  def refresh_token(conn, _params) do
    refresh_token = fetch_cookies(conn) |> Map.from_struct() |> get_in([:cookies, "ruid"])

    case Guardian.exchange(refresh_token, "refresh", "access") do
      {:ok, _old, {new_access_token, _new_claims}} ->
        conn
        |> put_status(:created)
        |> render(:token, access_token: new_access_token)

      _error ->
        conn
        |> put_status(401)
        |> json(%{error: "unauthorized"})
    end
  end

  def signout(conn, _params) do
    conn
    |> delete_resp_cookie("ruid")
    |> put_status(200)
    |> json(%{message: "Log out successful."})
  end
end
