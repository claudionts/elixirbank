defmodule ElixirbankWeb.AccountsViewTest do
  @moduledoc """
  Accounts view test
  """
  use ElixirbankWeb.ConnCase

  import Phoenix.View

  alias ElixirbankWeb.{AccountsView}
  alias Elixirbank.{User, Account}
  alias Elixirbank.Accounts.Transactions.Response, as: TransactionResponse

  @pass Faker.String.base64(8)
    
  @valid_params_user1 %{
    name: Faker.Person.PtBr.first_name(),
    password: @pass,
    nickname: Faker.Person.PtBr.first_name(),
    email: Faker.Internet.email(),
  }

  @valid_params_user2 %{
    name: Faker.Person.PtBr.first_name(),
    password: @pass,
    nickname: Faker.Person.PtBr.first_name(),
    email: Faker.Internet.email(),
  }

  setup %{} do
    {:ok, %User{} = user1} = Elixirbank.create_user(@valid_params_user1)

    {:ok, %User{} = user2} = Elixirbank.create_user(@valid_params_user2)
    
    {:ok, user1: user1, user2: user2}
  end

  test "renders update.json", %{
    user1: %User{
      account: %Account{
        id: account_id,
        balance: balance
      }
    },
    user2: _
  } do
    response = render(AccountsView, "update.json", account: %Account{id: account_id, balance: balance})

    expected_response = %{
      account: %{
        balance: balance,
        id: account_id
      },
      message: "Ballance changed successfully"
    }

    assert expected_response == response
  end

  test "renders transaction.json", %{
    user1: %User{
      account: %Account{
        id: from_id,
        balance: from_ballance
      } = account1
    },
    user2: %User{
      account: %Account{
        id: to_id,
        balance: to_ballance
      } = account2
    },
  } do
    transaction = TransactionResponse.build(account1, account2)

    response = render(AccountsView, "transaction.json", transaction: transaction)

    expected_response = %{
      message: "Transaction done successfully",
      transaction: %{
        from_account: %{
          balance: from_ballance,
          id: from_id,
        },
        to_account: %{
          balance: to_ballance,
          id: to_id,
        },
      },
    }
    assert expected_response == response
  end
end