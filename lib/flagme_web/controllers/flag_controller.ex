defmodule FlagmeWeb.FlagController do
  use FlagmeWeb, :controller

  alias Flagme.Flags

  def create(conn, params) do
    case Flags.create(params) do
      {:ok, flag} ->
        render(conn, :show, flag: flag)

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> put_view(FlagmeWeb.ErrorJSON)
        |> render("422.json")
    end
  end

  def get(conn, %{"name" => name}) do
    with :ok <- verify_permissions(conn, [:read_flags]),
         {:ok, flag} <- Flags.get(name) do
      render(conn, :show, flag: flag)
    else
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> put_view(FlagmeWeb.ErrorJSON)
        |> render("404.json")

      {:error, :unauthorized} ->
        conn
        |> put_status(401)
        |> json(%{error: "unauthorized", details: "missing permissions"})
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Flags.update(id, params) do
      {:ok, flag} ->
        render(conn, :show, flag: flag)

      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> put_view(FlagmeWeb.ErrorJSON)
        |> render("404.json")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> put_view(FlagmeWeb.ErrorJSON)
        |> render("422.json")
    end
  end
end
