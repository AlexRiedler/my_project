defmodule MyProjectWeb.UserController do
  use MyProjectWeb, :controller

  alias MyProject.Accounts

  action_fallback(MyProjectWeb.FallbackController)

  def me(conn, _params) do
    user = MyProject.Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
