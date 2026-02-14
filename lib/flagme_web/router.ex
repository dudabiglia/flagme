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
    post "/users/sign-in", SessionController, :signin
  end

  scope "/api/v1", FlagmeWeb do
    pipe_through [:api, :auth]

    post "/flags", FlagController, :create
    get "/flags/:name", FlagController, :get
    patch "/flags/:id", FlagController, :update

    post "/users/refresh-token", SessionController, :refresh_token
    post "/users/sign-out", SessionController, :signout
  end
end
