defmodule ElixirbankWeb.FallbackController do
  use ElixirbankWeb, :controller

  @spec call(Plug.Conn, %{error: Atom, result: String}) :: any()
  def call(conn, {:error, result})  do
    conn
    |>put_status(:bad_request)
    |>put_view(ElixirbankWeb.ErrorView)
    |>render("400.json", result: result)
  end
end
