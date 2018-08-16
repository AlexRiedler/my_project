defmodule MyProjectWeb.PageController do
  use MyProjectWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
