# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixirbank,
  ecto_repos: [Elixirbank.Repo]

# Configures the endpoint
config :elixirbank, ElixirbankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nDqbisiWTcoR1Pr1wyf+Xf4d1SEUW0R+MA0wv8UhwnDYMyDfeJpi4Yex20kg/nRP",
  render_errors: [view: ElixirbankWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Elixirbank.PubSub,
  live_view: [signing_salt: "kl9OGQpu"]

config :elixirbank, Elixirbank.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixirbank, ElixirbankWeb.Guardian,
  issuer: "elixirbank_web",
  secret_key: "3mJn44Ht8alG7R4Cb1qQpfxIEqtIuA65tDav3FYxyvZslDnzMvCWegy7u5MVjrvA"

config :elixirbank, ElixirbankWeb.AuthAccessPipeline,
  module: ElixirbankWeb.Guardian,
  error_handler: ElixirbankWeb.AuthErrorHandler
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
