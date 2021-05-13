defmodule Elixirbank.Accounts.Withdraw do
  @moduledoc """
  Run withdraw operation
  """
  alias Elixirbank.Accounts.Operation
  alias Elixirbank.Account
  alias Elixirbank.Repo

  @spec call(%{id: Ecto.UUID, value: Decimal}) :: {:ok, %Account{}} | {:ok, Account.changeset}
  def call(params) do
    params
    |>Operation.call(:withdraw)
    |>run_transaction()
  end

  @spec run_transaction(Ecto.Multi) :: {:ok, %Account{}} | {:ok, Account.changeset}
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{withdraw: account}} -> {:ok, account}
    end
  end
end
