defmodule MyProjectWeb.Router do
  use MyProjectWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(MyProjectWeb.AuthPipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/api/v1", MyProjectWeb do
    pipe_through([:api, :auth, :ensure_auth])
    get("/users/me", UserController, :me)
    resources("/challenges", ChallengeController, except: [:new, :edit])
  end

  scope "/api/v1/users", MyProjectWeb do
    pipe_through([:api, :auth])
    get("/:id", UserController, :show)
    post("/registrations", Users.RegistrationController, :create)
    post("/sessions", Users.SessionsController, :create)
    delete("/sessions", Users.SessionsController, :delete)
  end

  scope "/", MyProjectWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/challenge/:challenge_id", PageController, :challenge)
  end
end
