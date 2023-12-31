defmodule RockeliveryWeb.ErrorJSON do
  import Ecto.Changeset, only: [traverse_errors: 2]

  alias Ecto.Changeset

  def render("error.json", %{errors: %Changeset{} = errors}) do
    %{errors: parse_error(errors)}
  end

  def render("error.json", %{errors: errors}) do
    %{"errors" => errors}
  end

  defp parse_error(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> translate_value()
      end)
    end)
  end

  defp translate_value({:parametrized, Ecto.Enum, _map}), do: ""

  defp translate_value(value), do: to_string(value)
end
