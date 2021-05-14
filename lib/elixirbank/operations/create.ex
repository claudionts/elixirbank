defmodule Elixirbank.Operations.Create do
  @moduledoc """
  Registry each operation banking 
  """
  alias Elixirbank.Repo
  alias Elixirbank.Operation

  @spec call(%Operation{}) :: %Operation{}
  def call(params) do
    params
    |>Operation.changeset()
    |>Repo.insert()
  end
end