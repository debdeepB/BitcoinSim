defmodule BitcoinsimWeb.Router do
  use BitcoinsimWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BitcoinsimWeb do
    pipe_through :browser # Use the default browser stack

    post "/run/:id", SimulationController, :run
    resources "/", SimulationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BitcoinsimWeb do
  #   pipe_through :api
  # end
end
