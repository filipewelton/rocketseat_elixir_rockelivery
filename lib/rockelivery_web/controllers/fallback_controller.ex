defmodule RockeliveryWeb.FallbackController do
  use RockeliveryWeb, :controller

  alias RockeliveryWeb.ErrorJSON
  alias Rockelivery.Error

  def call(connection, %Error{status: status, result: result}) do
    connection
    |> put_status(status)
    |> put_view(ErrorJSON)
    |> render("error.json", errors: result)
  end

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorJSON)
    |> render("error.json", errors: result)
  end
end
