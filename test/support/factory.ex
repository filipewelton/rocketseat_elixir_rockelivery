defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  def user_params_factory do
    %{
      "age" => 18,
      "address" => "Av. Faria Lima",
      "cep" => "05875320",
      "email" => "username@domain.com",
      "password" => "1234567890132464763785",
      "name" => "Himura",
      "cpf" => "12345678901"
    }
  end
end
