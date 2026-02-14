defmodule Flagme.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Flagme.Repo
  alias Flagme.Accounts.User

  def create_user(params) do
    params
    |> User.signup_changeset()
    |> Repo.insert()
  end

  def get!(id) do
    Repo.get!(User, id)
  end

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def auth_user(email, password) do
    with {:ok, user} <- get_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password) do
      {:ok, user}
    else
      false -> {:error, :unauthorized}
      error -> error
    end
  end
end
