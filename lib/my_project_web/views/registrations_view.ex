defmodule MyProject.RegistrationView do 
  use MyProjectWeb, :view

  def render("error.json", %{changeset: changeset}) do 
    errors = changeset.errors 
    |> Enum.map(fn {field, msg} -> Map.put(%{}, field, render_detail(msg)) end)
    %{errors: errors}
  end

   defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
  end

  defp render_detail(message) do
    message
  end
end