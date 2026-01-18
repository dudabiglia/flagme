defmodule Flagme.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :enabled, :boolean, null: false, default: false
      add :enabled_perc, :integer, null: false
      add :inserted_by, :string, null: false

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:flags, [:name])
  end
end
