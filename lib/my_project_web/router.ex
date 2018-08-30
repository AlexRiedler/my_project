defmodule MyProjectWeb.Router do
  use MyProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
  end

  scope "/api", MyProjectWeb do
    pipe_through :api

    scope "/v1" do
      scope "/users" do
        post "/registrations", Users.RegistrationController, :create
        post "/sessions", Users.SessionsController, :create
        delete "/sessions", Users.SessionsController, :delete
      end
    end
  end

  scope "/", MyProjectWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
