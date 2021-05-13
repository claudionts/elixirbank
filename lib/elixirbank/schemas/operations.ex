defmodule Elixirbank.Operation do
  @moduledoc """
  Account Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirbank.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_param [:balance, :user_id]

  schema "operations" do
    field :value, :decimal
    field :type, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |>cast(params, @required_param)
    |>validate_required(@required_param)
    |>check_constraint(:value, name: :value_must_be_positive_or_zero)
  end
end
