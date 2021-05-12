defmodule Elixirbank.Users.Create do
  @moduledoc """
  User create related with account
  """
  alias Elixirbank.{Repo, User}

  alias Ecto.Multi
  alias Elixirbank.{Account, Repo, User}

  def call(params) do
    Multi.new
    |>Multi.insert(:create_user, User.changeset(params))
    |>Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user)
    end)
    |>Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    |>run_transaction()

  end

  defp insert_account(repo, user) do
    user.id
    |>account_changeset
    |>repo.insert
  end

  defp account_changeset(user_id), do: Account.changeset(%{user_id: user_id, balance: "1000.00"})

  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end

  def get_user(id) do
    case Repo.get_by(User, id: id) do
      nil -> {:error, "Account, not found!"}
      user -> preload_data(Repo, user)
    end
  end
end
