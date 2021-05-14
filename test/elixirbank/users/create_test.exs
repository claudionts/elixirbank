defmodule Elixirbank.Users.CreateTest do
  @moduledoc """
  User create related with account Test
  """
  use Elixirbank.DataCase

  alias Elixirbank.User
  alias Elixirbank.Users.Create

  describe "call/1" do
    @pass Faker.String.base64(8)

    @valid_params %{
      name: Faker.Person.PtBr.first_name(),
      password: @pass,
      nickname: Faker.Person.PtBr.first_name(),
      email: Faker.Internet.email(),
    }

    @invalid_params %{
      name: Faker.Person.PtBr.first_name(),
      password: @pass,
    }

    test "when all params are valid, returns an user" do 
      {:ok, %User{id: user_id}} = Create.call(@valid_params)
      user = Repo.get(User, user_id)
      assert %User{id: ^user_id} = user
    end
    
    test "when there are invalid params, returns an user" do
      {:error, changeset} = Create.call(@invalid_params)

      expected_response = %{
        nickname: ["can't be blank"],
        email: ["can't be blank"]
      }
      assert errors_on(changeset) == expected_response
    end

    test "get user for id" do
      {:ok, %User{id: user_id}} = Create.call(@valid_params)
      assert {:ok, %User{}} = Create.get_user_id(user_id)
    end
  end
end
