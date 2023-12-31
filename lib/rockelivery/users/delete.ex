defmodule Rockelivery.Users.Delete do
  alias Rockelivery.Repo
  alias Rockelivery.Users.Get

  def call(id) do
    with {:ok, user} <- Get.by_id(id),
         {:ok, _} <- Repo.delete(user) do
      :ok
    end
  end
end
