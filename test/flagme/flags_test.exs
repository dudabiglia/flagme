defmodule Flagme.FlagsTest do
  use Flagme.DataCase

  alias Flagme.Flags
  alias Flagme.Models.Flag

  test "inserts a flag" do
    params = %{
      name: "financed_cashout",
      enabled: true,
      enabled_perc: 50,
      inserted_by: "user"
    }

    assert {:ok,
            %Flag{
              name: "financed_cashout",
              enabled: true,
              enabled_perc: 50,
              inserted_by: "user",
              inserted_at: %NaiveDateTime{},
              updated_at: %NaiveDateTime{}
            }} = Flags.create(params)
  end
end
