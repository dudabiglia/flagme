defmodule Flagme.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:flags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
