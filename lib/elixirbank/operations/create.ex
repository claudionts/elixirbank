defmodule Elixirbank.Operations.Create do
  @moduledoc """
  Registry each operation banking
  """
  alias Elixirbank.{Repo, User}
  alias Elixirbank.Operation
  alias Ecto.Multi

  import Ecto.Query
  import Ecto.Query, only: [from: 2]

  @spec call(%Operation{}) :: %Operation{}
  def call(params) do
    params
    |>Operation.changeset()
    |>Repo.insert()
  end

  @spec extract(%User{}) :: %User{}
  def extract(%User{id: user_id}) do
    case get_extract_repo(user_id) do
      nil -> {:error, "Extract, not found!"}
      user -> {:ok, user}
    end
  end

  @spec get_extract_repo(Integer) :: %User{}
  defp get_extract_repo(user_id) do
    Repo.one(
      from(user in User,
        where: user.id == ^user_id,
        preload: [:account, :operation],
        select: [:id, :nickname, :email, :name]
    ))
  end

  @spec build(%Operation{}) :: %{}
  def build(%Operation{from_id: from_id, to_id: to_id, type: type, id: id, value: value}) do
    %{
      id: id,
      from_id: from_id,
      to_id: to_id,
      type: type,
      value: value
    }
  end

  @spec backoffice() :: any()
  def backoffice() do
    Multi.new()
    |>Multi.run("last_month", fn repo, _changes -> last_month(repo) end)
    |>Multi.run("last_year", fn repo, _changes -> last_year(repo) end)
    |>Multi.run("last_day", fn repo, _changes -> last_day(repo) end)
    |>run_transaction()
  end

  @spec run_transaction(%Ecto.Multi{}) :: {:error, String} | {:ok, map}
  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _} -> {:error, "Backoffice error"}
      {:ok, params} -> {:ok, params}
    end
  end

  @spec last_month(Ecto.Repo) :: any()
  defp last_month(repo) do
    case sum_query(repo, -30) do
      {:error, _} -> {:error, "Backoffice error"}
      [value] -> {:ok, value}
    end
  end

  @spec last_year(Ecto.Repo) :: any()
  defp last_year(repo) do
    case sum_query(repo, -365) do
      {:error, _} -> {:error, "Backoffice error"}
      [value] -> {:ok, value}
    end
  end

  @spec last_day(Ecto.Repo) :: any()
  defp last_day(repo) do
    case sum_query(repo, -1) do
      {:error, _} -> {:error, "Backoffice error"}
      [value] -> {:ok, value}
    end
  end

  @spec exact_date(Integer) :: String.t
  defp exact_date(days) do
    sub = (days * 24 * 3600)
    {:ok, date} = DateTime.now("Etc/UTC")
    DateTime.add(date, sub, :second)
    |>Calendar.strftime("%Y-%m-%d %H:%M:%S")
  end

  @spec sum_query(Ecto.Repo, Integer) :: any()
  defp sum_query(repo, day) do
    date = exact_date(day)
    repo.one(
      from(o in Operation,
        where: o.inserted_at >= ^date,
        select: [sum(o.value)]
      )
    )
  end
end
