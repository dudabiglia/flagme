defmodule FlagmeWeb.Router do
  use FlagmeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FlagmeWeb do
    pipe_through :api

    post "/test", TestController, :run

    post "/v1/flags", FlagController, :create
    patch "/v1/flags/:id", FlagController, :update
  end
end
