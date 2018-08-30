# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :my_project,
  ecto_repos: [MyProject.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :my_project, MyProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XioYptKqJ8JPl4YdIktj9wsglEgUYNWrk5+LcPqhJmrJNJLGHLJQ9Vum63BpevMI",
  render_errors: [view: MyProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MyProject.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :my_project, MyProject.Guardian,
  issuer: "my_project",
  secret_key: "IM1Sli8eabfa3M/zzo62NYQGa50e+rM6ku/eSblfS+hlD8MyhoMcSVJxG5hYFYHw"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
