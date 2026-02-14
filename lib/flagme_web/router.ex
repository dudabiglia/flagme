defmodule FlagmeWeb.Router do
  use FlagmeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Flagme.Auth.Pipeline
  end

  scope "/api/v1", FlagmeWeb do
    pipe_through :api

    post "/users", UserController, :signup
    post "/session/new", SessionController, :new
  end

  scope "/api/v1", FlagmeWeb do
    pipe_through [:api, :auth]

    post "/flags", FlagController, :create
    get "/flags/:name", FlagController, :get
    patch "/flags/:id", FlagController, :update

    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete
  end
end
