defmodule Elixirbank.AuthTest do
   @moduledoc """
  Verify Authenticated User Test
  """
  use Elixirbank.DataCase

  alias Elixirbank.{User, Auth}
  alias Elixirbank.Users.Create

  describe "run/2" do
    @pass Faker.String.base64(8)

    @valid_params %{
      name: Faker.Person.PtBr.first_name(),
      password: @pass,
      nickname: Faker.Person.PtBr.first_name(),
      email: Faker.Internet.email(),
    }
    
    test "when login is correct" do
      assert {:ok, %User{}} = Create.call(@valid_params)
      assert {:ok, %User{}} = Auth.run(@valid_params.email, @valid_params.password)
    end

    test "when password is correct" do
      assert {:error, :email_or_password_invalid} = Auth.run(@valid_params.email, "")
    end
  end
end