defmodule ElixirbankWeb.UsersController do
  use ElixirbankWeb, :controller

  alias Elixirbank.{Auth, User}
  alias ElixirbankWeb.Guardian
  alias ElixirbankWeb.Guardian.Plug, as: GuardianPlug

  action_fallback ElixirbankWeb.FallbackController

  @spec sign_in(Plug.Conn, %{email: String, password: String}) :: any()
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

  @spec current_user(Plug.Conn, map) :: any()
  def current_user(conn, _) do
    with {:ok, %User{} = user} <- GuardianPlug.current_resource(conn) do
     conn
     |>put_status(:ok)
     |>render("create.json", user: user)
    end
  end

  @spec create(Plug.Conn, %User{}) :: any()
  def create(conn, params) do
    params
    |>Elixirbank.create_user()
    |>handle_response(conn)
  end

  @spec handle_response({Atom, %User{}}, Plug.Conn) :: any()
  defp handle_response({:ok, %User{} = user}, conn) do
    conn
    |>put_status(:created)
    |>render("create.json", user: user)
  end

  @spec handle_response({Atom, String}, Plug.Conn) :: any()
  defp handle_response({:error, result}, conn) do
    conn
    |>put_status(:bad_request)
    |>put_view(ElixirbankWeb.ErrorView)
    |>render("400.json", result: result)
  end
end
