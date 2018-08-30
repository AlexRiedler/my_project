defmodule MyProjectWeb.UserController do
  use MyProjectWeb, :controller

  alias MyProject.Accounts

  action_fallback MyProjectWeb.FallbackController

  def me(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
