defmodule Elixirbank.Repo.Migrations.CreateUserTable do
  @moduledoc """
  Define Migration
  """
  use Ecto.Migration

  def change do
    create table :users do
      add :name, :string
      add :email, :string
      add :nickname, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])
  end
end
