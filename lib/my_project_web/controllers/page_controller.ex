defmodule MyProjectWeb.PageController do
  use MyProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def challenge(conn, %{"challenge_id" => challenge_id}) do
    challenge = MyProject.Challenges.get_challenge!(challenge_id)
    render(conn, "challenge.html", %{challenge: challenge})
  end
end
