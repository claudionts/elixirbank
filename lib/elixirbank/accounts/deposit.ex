defmodule Elixirbank.Accounts.Deposit do
  @moduledoc """
  Run deposit operation
  """
  alias Elixirbank.Accounts.Operation
  alias Elixirbank.Repo

  def call(params) do
    params
    |> Operation.call(:deposit)
    |> run_transaction()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{account_deposit: account}} -> {:ok, account}
    end
  end
end
