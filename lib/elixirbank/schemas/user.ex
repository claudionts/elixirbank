defmodule Elixirbank.User do
  @moduledoc """
  User Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirbank.{Account, Operation}
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :email, :nickname, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :nickname, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :account, Account
    has_many :operation, {"operations", Operation}, foreign_key: :from_id

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |>cast(params, @required_params)
    |>validate_required(@required_params)
    |>validate_length(:password, min: 6)
    |>validate_format(:email, ~r/@/)
    |>unique_constraint([:email])
    |>unique_constraint([:nickname])
    |>put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
#%{name: "Claudio 1", password: "123456", email: "claudionts1@gmail.com", nickname: "claudio1"}
