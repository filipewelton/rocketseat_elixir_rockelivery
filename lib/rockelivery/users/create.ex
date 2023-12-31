defmodule Rockelivery.Users.Create do
  alias Rockelivery.{Repo, Error, User}

  def call(%{"cep" => cep} = params) do
    with {:ok, %User{}} <- User.build(params),
         {:ok, _cep} <- client().get_cep_info(cep),
         {:ok, %User{} = user} <- create(params) do
      {:ok, user}
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:bad_request, result)}
      error -> error
    end
  end

  defp create(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  defp client do
    Application.fetch_env!(:rockelivery, __MODULE__)[:via_cep_adapter]
  end
end
