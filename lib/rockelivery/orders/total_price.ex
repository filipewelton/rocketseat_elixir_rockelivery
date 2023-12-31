defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Item

  def call(items) do
    Enum.reduce(items, Decimal.new("0.0"), &sum_price/2)
  end

  defp sum_price(%Item{price: price}, acc), do: Decimal.add(price, acc)
end
