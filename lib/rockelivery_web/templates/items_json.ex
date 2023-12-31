defmodule RockeliveryWeb.ItemsJSON do
  alias Rockelivery.Item

  def render("create.json", %{item: %Item{} = item}) do
    %{
      message: "Item created",
      item: item
    }
  end
end
