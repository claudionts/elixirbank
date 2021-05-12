defmodule ElixirbankWeb.AccountsController do
  use ElixirbankWeb, :controller

  alias Elixirbank.Account
  alias Elixirbank.Accounts.Transactions.Response, as: TransactionResponse

  action_fallback ElixirbankWeb.FallbackController

  @spec withdraw(conn :: %Plug.Conn{}, params :: map()) :: any()
  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- Elixirbank.deposit(params) do
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(conn :: %Plug.Conn{}, params :: map()) :: any()
  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- Elixirbank.withdraw(params) do
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(conn :: %Plug.Conn{}, params :: map()) :: any()
  def transaction(conn, params) do
    with {:ok, %TransactionResponse{} = transaction} <- Elixirbank.transaction(params) do
      conn
      |>put_status(:created)
      |>render("transaction.json", transaction: transaction)
    end
  end
end