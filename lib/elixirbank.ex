defmodule Elixirbank do
  @moduledoc """
  Define Global Funcionts
  """
  alias Elixirbank.Users.Create, as: UserCreate

  alias Elixirbank.Accounts.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate get_user(params), to: UserCreate, as: :get_user

  defdelegate deposit(params), to: Deposit, as: :call

  defdelegate withdraw(params), to: Withdraw, as: :call

  defdelegate transaction(params), to: Transaction, as: :call
end
