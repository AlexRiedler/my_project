defmodule MyProjectWeb.Users.SessionsController do 
  use MyProjectWeb, :controller

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case MyProjectWeb.Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, token, claims} = MyProject.Guardian.encode_and_sign(user)

        conn
          |> put_status(:created)
          |> MyProject.Guardian.Plug.sign_in(user)
          |> render("show.json", jwt: token, user: user)
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
      end
  end

  def delete(conn, _) do 
    {:ok, _claims} =
      conn
      |> Guardian.Plug.current_token
      |> MyProject.Guardian.revoke

    conn
    |> render("delete.json")
  end

  def unauthenticated(conn, _params) do 
    conn
    |> put_status(:forbidden)
    |> render(MyProjectWeb.SessionsView, "forbidden.json", error: "Not Authenticated!")
  end
end
