defmodule ElixirbankWeb.AccountsControllerTest do
  @moduledoc """
  AccountsController test
  """
  use ElixirbankWeb.ConnCase

  alias ElixirbankWeb.Guardian
  alias Elixirbank.{User, Account}

  describe "deposit/2" do
    @pass Faker.String.base64(8)
    
    @valid_params %{
      name: Faker.Person.PtBr.first_name(),
      password: @pass,
      nickname: Faker.Person.PtBr.first_name(),
      email: Faker.Internet.email(),
    }
    setup %{conn: conn} do
      {:ok, %User{account: %Account{id: account_id}} = user} = Elixirbank.create_user(@valid_params)

      {:ok, token, _} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer "<> token)

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |>post(Routes.accounts_path(conn, :deposit, account_id, params))
        |>json_response(:created)

      assert  %{
                "account" => %{"balance" => "1050.00", "id" => _id},
                "message" => "Ballance changed successfully"
              } = response
    end
  end
end
