defmodule ElixirbankWeb.OperationsView do
  alias Elixirbank.{Account, User}
  alias Elixirbank.Operations.Create, as: OperationsCreate

  def render("operation.json", %{
    user: %User{
      id: id,
      email: email,
      name: name,
      nickname: nickname,
      account: %Account{
        id: id_account,
        balance: balance,
      },
      operation: operation
    }
  }) do
    %{
      message: "Account statement",
      extract: %{
        user: %{
          id: id,
          email: email,
          name: name,
          nickname: nickname,
          account: %{
            id: id_account,
            balance: balance
          },
          operation: Enum.map(operation, fn o -> OperationsCreate.build(o) end)
        }
      }
    }
  end

  def render("backoffice.json", %{
    "last_month" => last_month,
    "last_year" => last_year,
    "last_day" => last_day
  }) do
    %{
      message: "Backoffice Data",
      backoffice: %{
        last_month: last_month,
        last_year: last_year,
        last_day: last_day
      }
    }
  end
end
