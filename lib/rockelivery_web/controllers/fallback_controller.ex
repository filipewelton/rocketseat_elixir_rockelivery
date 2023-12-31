defmodule RockeliveryWeb.FallbackController do
  use RockeliveryWeb, :controller

  alias Rockelivery.Error
  alias RockeliveryWeb.ErrorJSON

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
