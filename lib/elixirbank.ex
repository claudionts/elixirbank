defmodule Elixirbank do
  @moduledoc """
  Define Global Funcionts
  """
  alias Elixirbank.Users.Create, as: UserCreate

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate get_user(params), to: UserCreate, as: :get_user
end
