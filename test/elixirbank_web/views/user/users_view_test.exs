defmodule ElixirbankWeb.UsersViewTest do
  @moduledoc """
  Users view test
  """
  use ElixirbankWeb.ConnCase

  import Phoenix.View
  
  alias ElixirbankWeb.{Guardian, UsersView}
  alias Elixirbank.{User, Account}

  @pass Faker.String.base64(8)
    
  @valid_params %{
    name: Faker.Person.PtBr.first_name(),
    password: @pass,
    nickname: Faker.Person.PtBr.first_name(),
    email: Faker.Internet.email(),
  }

  setup %{} do
    {:ok, %User{} = user} = Elixirbank.create_user(@valid_params)

    {:ok, token, _} = Guardian.encode_and_sign(user)

    {:ok, user: user, token: token}
  end

  test "renders create.json", %{
    user: %User{
      id: user_id,
      name: name,
      nickname: nickname,
      account: %Account{
        id: account_id,
        balance: balance,
      },
    } = user,
    token: _
  } do
    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: balance,
          id: account_id
        },
        id: user_id,
        name: name,
        nickname: nickname
      }
    }

    assert expected_response == response
  end

  test "renders session.json", %{
    user: %User{
      name: name,
      nickname: nickname,
    } = user,
    token: token
  } do
    response = render(UsersView, "session.json", %{user: user, token: token})

    expected_response = %{
      message: "User Authenticated",
      data: %{
        user: %{
          name: name,
          nickname: nickname,
          token: token
        }
      }
    }

    assert expected_response == response
  end
end
