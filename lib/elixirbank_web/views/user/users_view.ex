defmodule ElixirbankWeb.UsersView do
  alias Elixirbank.{User, Account}

  def render("create.json", %{
    user: %User{
      account: %Account{
        id: account_id,
        balance: balance
      },
      id: id,
      name: name,
      nickname: nickname
      }
    }) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        nickname: nickname,
        account: %{
          id: account_id,
          balance: balance
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
