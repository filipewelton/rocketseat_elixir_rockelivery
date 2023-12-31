defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase

  import Rockelivery.Factory
  import Mox

  alias Rockelivery.{User, Error}
  alias Rockelivery.Users.Create
  alias Rockelivery.ViaCep.ClientMock

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok,
         %{
           "cep" => "01001000",
           "logradouro" => "Praça da Sé",
           "complemento" => "lado ímpar",
           "bairro" => "Sé",
           "localidade" => "São Paulo",
           "uf" => "SP",
           "ibge" => "3550308",
           "gia" => "1004",
           "ddd" => "11",
           "siafi" => "7107"
         }}
      end)

      response = Create.call(params)

      assert {:ok, %User{age: 18}} = response
    end

    test "when there are invalid params, return an error" do
      params =
        build(:user_params)
        |> Map.put("age", 1)

      response = Create.call(params)

      assert {:error, %Error{}} = response
    end
  end
end
