defmodule Rockelivery.Users.Get do
  alias Rockelivery.{Repo, User, Error}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> Error.build_user_not_found_error()
      user -> {:ok, user}
    end
  end
end
