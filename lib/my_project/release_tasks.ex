defmodule MyProject.ReleaseTasks do
  @otp_app :my_project
  @start_apps [:logger, :ssl, :postgrex, :ecto]

  def migrate do
    init(@otp_app, @start_apps)

    run_migrations_for(@otp_app)

    stop()
  end

  def seed do
    init(@otp_app, @start_apps)

    "#{seed_path(@otp_app)}/*.exs"
    |> Path.wildcard()
    |> Enum.sort()
    |> Enum.each(&run_seed_script/1)

    stop()
  end

  defp init(app, start_apps) do
    IO.puts "Loading app.."
    :ok = Application.load(app)

    IO.puts "Starting dependencies.."
    Enum.each(start_apps, &Application.ensure_all_started/1)

    IO.puts "Starting repos.."
    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(&(&1.start_link(pool_size: 1)))
  end

  defp stop do
    IO.puts "Success!"
    :init.stop()
  end

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"

    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(&Ecto.Migrator.run(&1, migrations_path(app), :up, all: true))
  end

  defp run_seed_script(seed_script) do
    IO.puts "Running seed script #{seed_script}.."
    Code.eval_file(seed_script)
  end

  defp migrations_path(app) do
    Application.app_dir(app, "priv/repo/migrations")
  end

  defp seed_path(app) do
    Application.app_dir(app, "priv/repo/seeds")
  end
end
