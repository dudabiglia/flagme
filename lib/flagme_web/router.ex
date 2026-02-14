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

    scope "/flags" do
      post "/", FlagController, :create
      get "/:name", FlagController, :get
      patch "/:id", FlagController, :update
    end

    scope "/users" do
      post "/", UserController, :signup
    end

    scope "/session" do
      post "/new", SessionController, :new
    end
  end

  scope "/api/v1", FlagmeWeb do
    pipe_through [:api, :auth]

    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete
  end
end
