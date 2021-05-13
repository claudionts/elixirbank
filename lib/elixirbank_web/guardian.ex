defmodule ElixirbankWeb.Guardian do
  @moduledoc """
  JWT Guardian
  """
  use Guardian, otp_app: :elixirbank
  alias Elixirbank.Users.Create, as: Users

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Users.get_user_id(id)
    {:ok,  resource}
  end
end
