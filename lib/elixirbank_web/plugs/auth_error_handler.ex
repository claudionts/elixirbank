defmodule ElixirbankWeb.AuthErrorHandler do
  @moduledoc """
  Middleware error
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @spec auth_error(%Plug.Conn{}, %{type: String, reason: String}, String) :: any()
  def auth_error(conn, {type, _reason}, _opts) do
    body = Phoenix.json_library().encode!(%{message: to_string(type)})

    conn
    |>put_resp_content_type("application/json")
    |>send_resp(401, body)
  end
end
