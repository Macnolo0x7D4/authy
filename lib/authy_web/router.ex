defmodule AuthyWeb.Router do
  use AuthyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AuthyWeb do
    pipe_through :api

    post "/auth/login", AuthController, :login  
    post "/auth/register", AuthController, :register
  end
end
