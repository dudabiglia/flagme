defmodule Flagme.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bcrypt.Base

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :password, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :permissions, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :permissions])
    |> validate_required([:first_name, :last_name, :email, :password, :permissions])
    |> unique_constraint(:email)
  end

  def signup_changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :permissions])
    |> validate_required([:first_name, :last_name, :email, :password, :permissions])
    |> encrypt_and_put_password()
    |> unique_constraint(:email)
  end

  defp encrypt_and_put_password(changeset) do
    password = get_field(changeset, :password)
    encrypted_password = Base.hash_password(password, Base.gen_salt(12, true))
    put_change(changeset, :password, encrypted_password)
  end
end
