defmodule MyProjectWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    body = %{error: to_string(type)} |> Poison.encode!
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
