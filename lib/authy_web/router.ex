defmodule AuthyWeb.Router do
  use AuthyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthyWeb do
    pipe_through :api

    post "/auth/login", UserController, :login  
    post "/auth/register", UserController, :register
    post "/auth/validate", UserController, :validate
  end
end
