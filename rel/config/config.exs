use Mix.Config

port = String.to_integer(System.get_env("PORT") || "4000")

config :my_project, MyProjectWeb.Endpoint,
  http: [port: port],
  url: [host: System.get_env("HOSTNAME"), port: port],
  server: true,
  code_reloader: false,
  root: ".",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info

config :my_project, MyProject.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 15
