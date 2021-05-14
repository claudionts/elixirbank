defmodule Elixirbank do
  @moduledoc """
  Define Global Funcionts
  """
  alias Elixirbank.Users.Create, as: UserCreate
  alias Elixirbank.Operations.Create, as: OperationCreate

  alias Elixirbank.Accounts.{Deposit, Transaction, Withdraw}
  alias Elixirbank.{Account, User, Operation}

  @spec create_user(%User{}) :: any()
  defdelegate create_user(params), to: UserCreate, as: :call

  @spec get_user(Integer) :: User.changeset
  defdelegate get_user(params), to: UserCreate, as: :get_user_id

  @spec deposit(%{id: Ecto.UUID, value: Decimal}) :: {:error, String} | {:ok, %Account{}}
  defdelegate deposit(params), to: Deposit, as: :call

  @spec withdraw(%{id: Ecto.UUID, value: Decimal}) :: {:ok, %Account{}} | {:ok, Account.changeset}
  defdelegate withdraw(params), to: Withdraw, as: :call

  @spec transaction(%{from: Ecto.UUID, to: Ecto.UUID, value: Decimal}) :: {:error, String} | {:ok, TransactionResponse.t() }
  defdelegate transaction(params), to: Transaction, as: :call
  
  @spec registry_operation(%{from_id: Ecto.UUID, to_id: Ecto.UUID, value: Decimal, type: String}) :: {:error, String} | {:ok, %Operation{} }
  defdelegate registry_operation(params), to: OperationCreate, as: :call
end
