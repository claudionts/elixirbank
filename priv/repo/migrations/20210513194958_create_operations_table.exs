defmodule Elixirbank.Repo.Migrations.CreateOperationsTable do
  @moduledoc """
  Create operations table migrate
  """
  use Ecto.Migration

  def change do
    create table :operations do
      add :value, :decimal
      add :type, :string
      add :from_id, references(:users, type: :binary_id)
      add :to_id, references(:users, type: :binary_id)

      timestamps()
    end

    create constraint(:accounts, :value_must_be_positive_or_zero, check: "value >=0")
  end
end
