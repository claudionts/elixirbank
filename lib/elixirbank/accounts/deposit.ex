defmodule Elixirbank.Accounts.Deposit do
  @moduledoc """
  Run deposit operation
  """
  alias Elixirbank.Accounts.Operation
  alias Elixirbank.Repo
  alias Elixirbank.Account

  @spec call(%{id: Ecto.UUID, value: Decimal}):: {:error, String} | {:ok, %Account{}}
  def call(params) do
    params
    |>Operation.call(:deposit)
    |>run_transaction()
  end

  @spec run_transaction(%Ecto.Multi{}) :: {:error, String} | {:ok, %Account{}}
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: account}} -> {:ok, account}
    end
  end
end
