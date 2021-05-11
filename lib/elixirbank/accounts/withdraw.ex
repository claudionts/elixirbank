defmodule Elixirbank.Accounts.Withdraw do
  @moduledoc """
  Run withdraw operation
  """
  alias Elixirbank.Accounts.Operation
  alias Elixirbank.Repo

  def call(params) do
    params
    |>Operation.call(:withdraw)
    |>run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{account_withdraw: account}} -> {:ok, account}
    end
  end
end
