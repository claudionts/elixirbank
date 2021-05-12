defmodule Elixirbank.Accounts.Transactions.Response do
  @moduledoc """
  Build transaciton operation struct
  """
  alias Elixirbank.Account
  defstruct [:from_account, :to_account]

  @type t :: %__MODULE__{from_account: %Account{}, to_account: %Account{}}

  @spec build(%Account{}, %Account{}) :: t
  def build(%Account{} = from_account, %Account{} = to_account) do
    %__MODULE__{
      from_account: from_account,
      to_account: to_account
    }
  end
end
