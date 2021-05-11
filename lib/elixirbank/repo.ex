defmodule Elixirbank.Repo do
  use Ecto.Repo,
    otp_app: :elixirbank,
    adapter: Ecto.Adapters.Postgres
end
