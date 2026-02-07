defmodule Flagme.Flags do
  alias Flagme.Repo
  alias Flagme.Models.Flag
  alias Flagme.Cache

  require Logger

  def create(params) do
    params
    |> Flag.changeset()
    |> Repo.insert(on_conflict: :nothing)
    |> case do
      {:ok, flag} ->
        Cache.add(flag)
        {:ok, flag}

      error ->
        error
    end
  end

  def get(name) do
    case Cache.get(name) do
      [{_name, data}] ->
        Logger.info("Retrieved flag from CACHE name=#{name}")
        {:ok, data}

      _ ->
        case Repo.get_by(Flag, name: name) do
          nil ->
            {:error, :not_found}

          flag ->
            Logger.info("Retrieved flag from DATABASE name=#{name}")
            Cache.add(flag)
            {:ok, flag}
        end
    end
  end

  def update(id, params) do
    case Repo.get(Flag, id) do
      nil ->
        {:error, :not_found}

      flag ->
        flag
        |> Flag.update_changeset(params)
        |> Repo.update()
        |> case do
          {:ok, flag} ->
            Cache.add(flag)
            {:ok, flag}

          error ->
            error
        end
    end
  end
end
