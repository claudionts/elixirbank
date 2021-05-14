defmodule Elixirbank.Operation do
  @moduledoc """
  Account Schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Elixirbank.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @params_build [:value, :type, :from_id, :to_id]
  @required_param [:value, :type, :from_id]

  schema "operations" do
    field :value, :decimal
    field :type, :string
    belongs_to :user_from, User, foreign_key: :from_id, references: :id
    belongs_to :user_to, User, foreign_key: :to_id, references: :id

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |>cast(params, @params_build)
    |>validate_required(@required_param)
    |>check_constraint(:value, name: :value_must_be_positive_or_zero)
  end
end
