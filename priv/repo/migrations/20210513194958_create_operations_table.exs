defmodule Elixirbank.Repo.Migrations.CreateOperationsTable do
  @moduledoc """
  Create operations table migrate
  """
  use Ecto.Migration

  def change do
    create table :operations do
      add :value, :decimal
      add :type, :string
      add :from_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :to_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create constraint(:operations, :value_must_be_positive_or_zero, check: "value >=0")
  end
end
