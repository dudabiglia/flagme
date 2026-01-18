defmodule FlagmeWeb.FlagJSON do
  def render("show.json", %{flag: flag}) do
    %{
      data: flag
    }
  end
end
