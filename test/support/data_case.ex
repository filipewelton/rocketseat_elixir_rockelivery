defmodule Rockelivery.DataCase do
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Ecto.Changeset
  alias Rockelivery.Repo

  using do
    quote do
      alias Rockelivery.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Rockelivery.DataCase
    end
  end

  setup tags do
    Rockelivery.DataCase.setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
