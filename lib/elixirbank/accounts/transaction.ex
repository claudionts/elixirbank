defmodule Elixirbank.Accounts.Transaction do
  @moduledoc """
  Run bank transaction
  """
  alias Ecto.Multi

  alias Elixirbank.Accounts.Operation
  alias Elixirbank.Accounts.Transactions.Response, as: TransactionResponse
  alias Elixirbank.Repo

  @spec call(%{from: Ecto.UUID, to: Ecto.UUID, value: Decimal}) :: {:error, String} | {:ok, TransactionResponse.t() }
  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    |>Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
    |>Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
    |>run_transaction()
  end

  @spec build_params(Integer, Decimal) :: %{id: Integer, value: Decimal}
  defp build_params(id, value) , do: %{"id" => id, "value" => value}

  @spec run_transaction(Ecto.Multi) :: {:error, String} | {:ok, TransactionResponse.t() }
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
