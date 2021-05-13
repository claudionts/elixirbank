defmodule Elixirbank.Accounts.Operation do
  @moduledoc """
  Defines deposit and withdrawal operations
  """
  alias Ecto.Multi

  alias Elixirbank.{Account, User}

  @spec call(%{user_id: Ecto.UUID, value: Decimal}, Atom) :: %Account{}
  def call(%{"id" => user_id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)
    Multi.new()
    |>Multi.run(operation_name, fn repo, _changes -> get_account(repo, user_id) end)
    |>Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)

      update_balance(repo, account, value, operation)
    end)
  end

  @spec get_account(Ecto.Repo, Integer) :: {:error, String} | {:ok, %Account{}}
  defp get_account(repo, id) do
    case repo.get_by(Account, [user_id: id]) do
      nil -> {:error, "Account, not found!"}
      account -> {:ok, account}
    end
  end

  @spec update_balance(Ecto.Repo, %Account{}, Decimal, Atom) :: %Account{}
  defp update_balance(repo, account, value, operation) do
    account
    |>operation(value, operation)
    |>update_account(repo, account)
  end

  @spec operation(%Account{}, value :: Decimal, operation :: Atom) :: Decimal | map()
  defp operation(%Account{balance: balance}, value, operation) do
    value
    |>Decimal.cast()
    |>handle_cast(balance, operation)
  end

  @spec handle_cast({Atom, String}, Decimal, Atom) :: Decimal
  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  @spec handle_cast({Atom, String}, Decimal, Atom) :: Decimal
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  @spec handle_cast({Atom, String}, Decimal, Atom) :: {:error, String}
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value!"}

  @spec update_account({Atom, String}, Ecto.Repo, %Account{}) :: Atom
  defp update_account({:error, _reason} = error, _repo, _account), do: error

  @spec update_account(Decimal, Ecto.Repo, %Account{}) :: %Account{}
  defp update_account(value, repo, account) do
    params = %{balance: value}

    account
    |>Account.changeset(params)
    |>repo.update()
  end

  @spec account_operation_name(Atom) :: String
  defp account_operation_name(operation) do
    "account_#{Atom.to_string(operation)}" |>String.to_atom()
  end
end
