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
  def deposit(conn, %{"value" => value} = params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "id", user_id)
    with {:ok, %Account{} = account} <- Elixirbank.deposit(params) do
      Elixirbank.registry_operation(%{
        "from_id" => user_id,
        "value" => value,
        "type" => "deposit"
      })
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(%Plug.Conn{}, %{value: Decimal}) :: any()
  def withdraw(conn, %{"value" => value} = params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "id", user_id)
    with {:ok, %Account{} = account} <- Elixirbank.withdraw(params) do
      Elixirbank.registry_operation(%{
        "from_id" => user_id,
        "value" => value,
        "type" => "withdraw"
      })
      conn
      |>put_status(:created)
      |>render("update.json", account: account)
    end
  end

  @spec withdraw(%Plug.Conn{}, %{to: Ecto.UUID, value: Decimal}) :: any()
  def transaction(conn, %{"to" => to, "value" => value} = params) do
    {:ok, %User{id: user_id}} = GuardianPlug.current_resource(conn)
    params = Map.put(params, "from", user_id)
    with {:ok, %TransactionResponse{} = transaction} <- Elixirbank.transaction(params) do
      Elixirbank.registry_operation(%{
        "from_id" => user_id,
        "to_id" => to,
        "value" => value,
        "type" => "transaction"
      })
      conn
      |>put_status(:created)
      |>render("transaction.json", transaction: transaction)
    end
  end
end
