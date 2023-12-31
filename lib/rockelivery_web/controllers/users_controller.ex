defmodule RockeliveryWeb.UsersController do
  use RockeliveryWeb, :controller

  import Rockelivery

  alias RockeliveryWeb.FallbackController
  alias RockeliveryWeb.Auth.Guardian

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, user} <- create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user, token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- delete_user(id) do
      conn
      |> put_status(204)
      |> text("")
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def update(conn, params) do
    with {:ok, user} <- update_user(params) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end
end
