# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  # If you are running Phoenix, you should make sure that
  # server: true is set and the code reloader is disabled,
  # even in dev mode.
  # It is recommended that you build with MIX_ENV=prod and pass
  # the --env flag to Distillery explicitly if you want to use
  # dev mode.
  set dev_mode: true
  set include_erts: false
  set cookie: :"7eQtE`R1fIn<3n^}ZhCx<r9a(d8a2~2mS/xUq1?_P&%b^Vzvy?T4^1xMogCBJOqJ"
  set commands: [
    seed: "rel/commands/seed.sh",
    migrate: "rel/commands/migrate.sh",
  ]
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"S*ECFvdHVuM6pv,(9iw3>jeHQ}ICZ<(D4~8,aUG*eiKYfp^3!CMcFND<dl.nC:SB"

  set commands: [
    seed: "rel/commands/seed.sh",
    migrate: "rel/commands/migrate.sh",
  ]
  set post_start_hooks: "rel/hooks/post_start_hooks"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :my_project do
  set version: current_version(:my_project)
  set applications: [
    :runtime_tools
  ]
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
  set overlays: [
    {:copy, "rel/config/config.exs", "etc/config.exs"}
  ]
end

