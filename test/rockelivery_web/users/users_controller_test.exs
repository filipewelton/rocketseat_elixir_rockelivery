defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Rockelivery.Factory
  import Mox

  alias Rockelivery.Users.Create
  alias Rockelivery.ViaCep.ClientMock
  alias RockeliveryWeb.Auth.Guardian

  setup do
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

    :ok
  end

  describe "create/2" do
    test "when all params are valid, return the user", %{conn: conn} do
      params = build(:user_params)

      conn
      |> post("/api/users", params)
      |> json_response(201)
    end

    test "when there is some error, returns error", %{conn: conn} do
      params =
        build(:user_params)
        |> Map.put("cep", "123")

      conn
      |> post("/api/users", params)
      |> json_response(400)
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      {:ok, user} =
        build(:user_params)
        |> Create.call()

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, id: user.id}
    end

    test "when there is a user with the given id, delete the user", %{conn: conn, id: id} do
      conn
      |> delete("/api/users/#{id}")
      |> response(204)
    end
  end

  describe "sign-in" do
    @password "12345678901234567"

    setup do
      {:ok, user} =
        build(:user_params)
        |> Map.put("password", @password)
        |> Create.call()

      %{user_id: user.id}
    end

    test "when all parameters is valid", %{conn: conn, user_id: user_id} do
      params = %{
        "id" => user_id,
        "password" => @password
      }

      conn
      |> post("/api/users/sign-in", params)
      |> json_response(200)
    end
  end
end
