defmodule MyProjectWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    body = to_string(type)
    IO.inspect type
    IO.inspect reason
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
