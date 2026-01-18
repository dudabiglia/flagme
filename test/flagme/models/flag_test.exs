defmodule Flagme.Models.FlagTest do
  use ExUnit.Case

  alias Flagme.Models.Flag

  describe "changeset/2" do
    test "returns valid changeset with valid params" do
      params = %{
        name: "financed_cashout",
        enabled: true,
        enabled_perc: 50,
        inserted_by: "user"
      }

      assert %Ecto.Changeset{valid?: true, changes: ^params} =
               Flag.changeset(params)
    end

    test "returns invalid changeset when missing required params" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 name: {"can't be blank", [validation: :required]},
                 enabled: {"can't be blank", [validation: :required]},
                 enabled_perc: {"can't be blank", [validation: :required]},
                 inserted_by: {"can't be blank", [validation: :required]}
               ]
             } =
               Flag.changeset(%{})
    end

    test "returns invalid changeset when perc not between 0 and 100" do
      params = %{
        name: "financed_cashout",
        enabled: true,
        enabled_perc: -1,
        inserted_by: "user"
      }

      assert %Ecto.Changeset{
               valid?: false,
               errors: [enabled_perc: {"should be between 0 and 100", []}]
             } =
               Flag.changeset(params)

      assert %Ecto.Changeset{
               valid?: false,
               errors: [enabled_perc: {"should be between 0 and 100", []}]
             } =
               Flag.changeset(Map.put(params, :enabled_perc, 101))
    end
  end

  describe "disable_changeset/2" do
    test "returns valid changeset with valid params" do
      params = %{
        id: UUID.uuid4(),
        enabled: true,
        enabled_perc: 60
      }

      assert %Ecto.Changeset{valid?: true, changes: ^params} =
               Flag.update_changeset(params)
    end

    test "returns invalid changeset when missing invalid params" do
      assert %Ecto.Changeset{
               valid?: false,
               errors: [
                 id: {"can't be blank", [validation: :required]},
                 enabled: {"can't be blank", [validation: :required]},
                 enabled_perc: {"can't be blank", [validation: :required]}
               ]
             } =
               Flag.update_changeset(%{})
    end
  end
end
