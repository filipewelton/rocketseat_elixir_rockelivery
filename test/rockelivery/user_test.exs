defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      params = build(:user_params)
      response = User.changeset(params)

      assert %Changeset{valid?: true} = response
    end

    test "when updating a changeset, returns a valid changeset with the given changes" do
      params = build(:user_params)
      update_params = %{name: "Yamamura"}

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      assert %Changeset{valid?: true, changes: %{name: "Yamamura"}} = response
    end

    test "when there some are error, returns an invalid changeset" do
      params =
        build(:user_params)
        |> Map.put("age", 17)

      update_params = %{name: "Yamamura"}

      response =
        params
        |> User.changeset()
        |> User.changeset(update_params)

      expected_response = %{
        age: ["must be greater than or equal to 18", "must be greater than or equal to 18"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
