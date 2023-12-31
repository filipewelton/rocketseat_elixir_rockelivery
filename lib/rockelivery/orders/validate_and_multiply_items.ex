defmodule Rockelivery.Orders.ValidateAndMultiplyItems do
  alias Rockelivery.Error

  def call(items, items_ids, items_params) do
    items_map = Map.new(items, fn item -> {item.id, item} end)

    items_ids
    |> Enum.map(fn id -> {id, Map.get(items_map, id)} end)
    |> Enum.any?(fn {_id, value} -> is_nil(value) end)
    |> duplicate_items(items_map, items_params)
  end

  defp duplicate_items(true, _items, _items_params) do 
    {:error, Error.build(:bad_request, "Invalid ID(s)")}
  end

  defp duplicate_items(false, items, items_params) do
    items = Enum.reduce(items_params, [], fn %{"id" => id, "quantity" => quantity}, acc ->
      item = Map.get(items, id)
      acc ++ List.duplicate(item, quantity)
    end)

    {:ok, items}
  end
end
