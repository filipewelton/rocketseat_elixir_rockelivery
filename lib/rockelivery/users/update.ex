defmodule Rockelivery.Users.Update do
  alias Rockelivery.{Error, Repo, User}

  def call(params) do
    %{"id" => id} = params

    case Repo.get(User, id) do
      nil -> Error.build_user_not_found_error()
      user -> handle_update(user, params)
    end
  end

  defp handle_update(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
