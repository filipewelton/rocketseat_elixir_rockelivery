defmodule RockeliveryWeb.WelcomeController do
  use RockeliveryWeb, :controller

  def index(connection, _params) do
    connection
    |> put_status(:ok)
    |> text("Welcome")
  end
end
