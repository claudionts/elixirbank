defmodule ElixirbankWeb.UsersView do
  alias Elixirbank.User

  def render("create.json", %{user: %User{id: id, name: name, nickname: nickname}}) do
    %{
      message: "User created",
      data: %{
        user: %{
          id: id,
          name: name,
          nickname: nickname
        }
      }
    }
  end

  def render("session.json", %{user: %{name: name, nickname: nickname}, token: token}) do
    %{
      message: "User Authenticated",
      data: %{
        user: %{
          name: name,
          nickname: nickname,
          token: token
        }
      }
    }
  end
end
