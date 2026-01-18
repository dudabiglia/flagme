defmodule Flagme.Models.Flag do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "flags" do
    field :name
    field :enabled, :boolean
    field :enabled_perc, :integer
    field :inserted_by

    timestamps(type: :naive_datetime_usec)
  end

  def changeset(flag \\ %__MODULE__{}, params) do
    fields = __schema__(:fields)

    flag
    |> cast(params, fields)
    |> validate_required([:name, :enabled, :enabled_perc, :inserted_by])
    |> validate_enabled_perc()
  end

  def update_changeset(flag \\ %__MODULE__{}, params) do
    flag
    |> cast(params, [:enabled, :enabled_perc])
    |> validate_required([:enabled, :enabled_perc])
    |> validate_enabled_perc()
  end

  defp validate_enabled_perc(changeset) do
    changeset
    |> get_change(:enabled_perc)
    |> case do
      nil ->
        changeset

      perc ->
        if perc >= 0 and perc <= 100 do
          changeset
        else
          add_error(changeset, :enabled_perc, "should be between 0 and 100")
        end
    end
  end
end
