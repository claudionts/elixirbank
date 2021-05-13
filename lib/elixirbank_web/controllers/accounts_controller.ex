defmodule ElixirbankWeb.AccountsController do
  @moduledoc """
  Run accounts operations
  """
  use ElixirbankWeb, :controller

  alias Elixirbank.{Account, User}
  alias Elixirbank.Accounts.Transactions.Response, as: TransactionResponse
  alias ElixirbankWeb.Guardian.Plug, as: GuardianPlug

  action_fallback ElixirbankWeb.FallbackController

  @spec deposit(%Plug.Conn{}, %{value: Decimal}) :: any()
  def deposit(conn, params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "id", user_id)
    with {:ok, %Account{} = account} <- Elixirbank.deposit(params) do
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(%Plug.Conn{}, %{value: Decimal}) :: any()
  def withdraw(conn, params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "id", user_id)
    with {:ok, %Account{} = account} <- Elixirbank.withdraw(params) do
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(%Plug.Conn{}, %{to: Ecto.UUID, value: Decimal}) :: any()
  def transaction(conn, params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "from", user_id)
    with {:ok, %TransactionResponse{} = transaction} <- Elixirbank.transaction(params) do
      conn
      |>put_status(:created)
      |>render("transaction.json", transaction: transaction)
    end
  end
end
