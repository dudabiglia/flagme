defmodule Flagme.Flags do
  alias Flagme.Repo
  alias Flagme.Models.Flag

  def create(params) do
    params
    |> Flag.changeset()
    |> Repo.insert(on_conflict: :nothing)
  end

  def update(id, params) do
    case Repo.get(Flag, id) do
      nil ->
        {:error, :not_found}

      flag ->
        flag
        |> Flag.update_changeset(params)
        |> Repo.update()
    end
  end
end
