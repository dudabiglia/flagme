defmodule FlagmeWeb.Router do
  use FlagmeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FlagmeWeb do
    pipe_through :api

    post "/v1/flags", FlagController, :create
    get "/v1/flags/:name", FlagController, :get
    patch "/v1/flags/:id", FlagController, :update
  end
end
