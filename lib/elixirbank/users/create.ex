defmodule Elixirbank.Users.Create do
  @moduledoc """
  User Operations
  """
  alias Elixirbank.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, "Account, not found!"}
      user -> {:ok, user}
    end
  end
end
