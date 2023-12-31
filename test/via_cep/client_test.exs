defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case

  alias Plug.Conn
  alias Rockelivery.ViaCep.Client
  alias Rockelivery.Error

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()
      url = "http://localhost:#{bypass.port}/"

      {:ok, bypass: bypass, url: url}
    end

    test "when there is a valid cep, returns the cep info", %{bypass: bypass, url: url} do
      cep = "01001000"
      body = ~s({
        "cep": "#{cep}",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      Bypass.expect(bypass, fn conn ->
        assert conn.method == "GET"
        assert conn.request_path == "/#{cep}/json"

        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_body = %{
        "cep" => "#{cep}",
        "logradouro" => "Praça da Sé",
        "complemento" => "lado ímpar",
        "bairro" => "Sé",
        "localidade" => "São Paulo",
        "uf" => "SP",
        "ibge" => "3550308",
        "gia" => "1004",
        "ddd" => "11",
        "siafi" => "7107"
      }

      assert {:ok, body} = response
      assert body === expected_body
    end

    test "when the cep is invalid, return an error", %{bypass: bypass, url: url} do
      cep = "0100"

      Bypass.expect(bypass, fn conn ->
        assert conn.method == "GET"
        assert conn.request_path == "/#{cep}/json"

        Conn.resp(conn, 400, "")
      end)

      response = Client.get_cep_info(url, cep)
      expected = %Error{status: :bad_request, result: "Invalid CEP!"}

      assert {:error, error} = response
      assert error === expected
    end

    test "when the cep was not found, returns an error", %{bypass: bypass, url: url} do
      cep = "12345678"
      body = ~s({"body": true})

      Bypass.expect(bypass, fn conn ->
        assert conn.method == "GET"
        assert conn.request_path == "/#{cep}/json"

        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(400, body)
      end)

      response = Client.get_cep_info(url, cep)
      expected = %Error{status: :bad_request, result: "Invalid CEP!"}

      assert {:error, error} = response
      assert error == expected
    end

    test "when there is a generic error, returns an error", %{bypass: bypass, url: url} do
      cep = "12345678"

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)
      expected = %Error{status: :bad_request, result: :econnrefused}

      assert {:error, error} = response
      assert error == expected
    end
  end
end
