defmodule ElixirbankWeb.Router do
  use ElixirbankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug ElixirbankWeb.AuthAccessPipeline
  end

  scope "/api", ElixirbankWeb do
    pipe_through :api
    post "/users", UsersController, :create
    post "/signin", UsersController, :sign_in
  end

  scope "/api", ElixirbankWeb do
    pipe_through :api_auth
    get "/user/:id", UsersController, :get_user
    post "/accounts/:id/deposit", AccountsController, :deposit
    post "/accounts/:id/withdraw", AccountsController, :withdraw
    post "/accounts/transaction", AccountsController, :transaction
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ElixirbankWeb.Telemetry
    end
  end
end
