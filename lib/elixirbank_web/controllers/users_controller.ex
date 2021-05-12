defmodule ElixirbankWeb.UsersController do
  use ElixirbankWeb, :controller

  alias Elixirbank.{Auth, User}
  alias ElixirbankWeb.Guardian

  action_fallback ElixirbankWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.run(email, password) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user)
        render(conn, "session.json", %{user: user, token: token})

      {:error, _} ->
        conn
        |>put_status(401)
        |>json(%{status: "unauthenticated"})
    end
  end

  def get_user(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Elixirbank.get_user(id) do
     conn
     |>put_status(:ok)
     |>render("create.json", user: user)
    end
  end

  def create(conn, params) do
    params
    |>Elixirbank.create_user()
    |>handle_response(conn)
  end

  defp handle_response({:ok, %User{} = user}, conn) do
    conn
    |>put_status(:created)
    |>render("create.json", user: user)
  end

  defp handle_response({:error, result}, conn) do
    conn
    |>put_status(:bad_request)
    |>put_view(ElixirbankWeb.ErrorView)
    |>render("400.json", result: result)
  end
end
