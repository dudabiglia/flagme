defmodule FlagmeWeb.UserController do
  use FlagmeWeb, :controller

  alias Flagme.Accounts

  action_fallback FlagmeWeb.FallbackController

  def signup(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{id: user.id, email: user.email})

      error ->
        error
    end
  end
end
