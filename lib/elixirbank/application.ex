defmodule Elixirbank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Elixirbank.Repo,
      # Start the Telemetry supervisor
      ElixirbankWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Elixirbank.PubSub},
      # Start the Endpoint (http/https)
      ElixirbankWeb.Endpoint
      # Start a worker by calling: Elixirbank.Worker.start_link(arg)
      # {Elixirbank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirbank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirbankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
