defmodule Elixirbank.Operations.Create do
  @moduledoc """
  Registry each operation banking
  """
  alias Elixirbank.{Repo, User}
  alias Elixirbank.Operation
  import Ecto.Query
  import Ecto.Query, only: [from: 2]

  @spec call(%Operation{}) :: %Operation{}
  def call(params) do
    params
    |>Operation.changeset()
    |>Repo.insert()
  end

  @spec extract(%User{}) :: %User{}
  def extract(%User{id: user_id}) do
    case get_extract_repo(user_id) do
      nil -> {:error, "Extract, not found!"}
      user -> {:ok, user}
    end
  end

  @spec get_extract_repo(Integer) :: %User{}
  defp get_extract_repo(user_id) do
    Repo.one(
      from(user in User,
        where: user.id == ^user_id,
        preload: [:account, :operation],
        select: [:id, :nickname, :email, :name]
    ))
  end

  def build(%Operation{from_id: from_id, to_id: to_id, type: type, id: id}) do
    %{
      from_id: from_id,
      to_id: to_id,
      type: type,
      id: id
    }
  end

end
