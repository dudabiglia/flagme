defmodule Flagme.Cache do
  use GenServer

  require Logger

  # client-facing

  def start_link(state \\ %{}) do
    Logger.info("Starting flag cache")
    GenServer.start_link(__MODULE__, state, name: :flagme_cache)
  end

  def add(flag), do: GenServer.cast(:flagme_cache, {:add, flag})
  def drop(flag), do: GenServer.cast(:flagme_cache, {:drop, flag})

  def get(name), do: GenServer.call(:flagme_cache, {:get, name})
  def list, do: GenServer.call(:flagme_cache, :list)

  # callbacks

  @impl true
  def init(_state) do
    :ets.new(:flags, [:set, :public, :named_table])

    {:ok, %{}}
  end

  @impl true
  def handle_cast({:add, flag}, state) do
    Logger.info("Adding to cache #{flag.name}")

    :ets.insert(:flags, {flag.name, flag})

    {:noreply, state}
  end

  @impl true
  def handle_cast({:drop, name}, state) do
    Logger.info("Dropping flag from cache #{name}")

    :ets.delete(:flags, name)

    {:noreply, state}
  end

  @impl true
  def handle_call({:get, name}, _, state) do
    Logger.info("Retrieving from cache #{name}")

    result = :ets.lookup(:flags, name)

    {:reply, result, state}
  end

  @impl true
  def handle_call(:list, _, state) do
    Logger.info("Listing")

    result = :ets.tab2list(:flags)

    {:reply, result, state}
  end
end
