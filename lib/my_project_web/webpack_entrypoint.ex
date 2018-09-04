defmodule MyProjectWeb.WebpackEntrypoint do
  if Mix.env() == :prod do
    @manifest :code.priv_dir(:my_project)
              |> Path.join("static/manifest.json")
              |> File.read!()
              |> Poison.decode!()
    def webpack_entrypoint_path(_conn, name), do: @manifest[name]
  else
    def webpack_entrypoint_path(_conn, name) do
      manifest =
        :code.priv_dir(:my_project)
        |> Path.join("static/manifest.json")
        |> File.read!()
        |> Poison.decode!()

      manifest[name]
    end
  end
end
