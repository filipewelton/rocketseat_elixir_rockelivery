defmodule RockeliveryWeb.UsersJSON do
  alias Rockelivery.User

  def render("create.json", %{user: user, token: token}) do
    %{
      message: "User created successfully",
      user: user,
      token: token
    }
  end

  def render("user.json", %{user: %User{} = user}), do: user

  def render("sign_in.json", %{token: token}), do: %{token: token}
end
