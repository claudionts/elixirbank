defmodule ElixirbankWeb.AuthAccessPipeline do
  @moduledoc """
  Guardian pipeline plugs verify
  """
  use Guardian.Plug.Pipeline, otp_app: :elixirbank

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
