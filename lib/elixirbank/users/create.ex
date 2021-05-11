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

  def get_user(id), do: Repo.get(User, id)
end
