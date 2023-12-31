defmodule RockeliveryWeb.OrdersJSON do
  alias Rockelivery.Order

  def render("create.json", %{order: %Order{} = order}) do
    %{
      message: "Order created",
      order: order
    }
  end
end
