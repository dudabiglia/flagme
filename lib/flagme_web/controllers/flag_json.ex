defmodule FlagmeWeb.FlagJSON do
  def show(%{flag: flag}) do
    %{data: flag}
  end
end
