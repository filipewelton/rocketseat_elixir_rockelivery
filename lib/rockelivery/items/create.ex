defmodule Rockelivery.Items.Create do
  alias Rockelivery.{Error, Item, Repo}

  def call(params) do
    params
    |> Item.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Item{}} = result), do: result

  defp handle_insert({:error, changeset}) do
    Error.build(:bad_request, result: changeset)
  end
end
