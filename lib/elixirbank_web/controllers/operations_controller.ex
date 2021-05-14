defmodule ElixirbankWeb.OperationsController do
  @moduledoc """
  Run operations
  """
  use ElixirbankWeb, :controller

  alias ElixirbankWeb.Guardian.Plug, as: GuardianPlug
  alias Elixirbank.User

  action_fallback ElixirbankWeb.FallbackController

  @spec extract(%Plug.Conn{}, %{}) :: any()
  def extract(conn, _) do
    {:ok, %User{} = user_auth} = GuardianPlug.current_resource(conn)
    with {:ok, %User{} = user} <- Elixirbank.extract(user_auth) do
      conn
      |>put_status(:ok)
      |>render("operation.json", user: user)
    end
  end
end
