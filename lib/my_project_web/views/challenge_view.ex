defmodule MyProjectWeb.ChallengeView do
  use MyProjectWeb, :view
  alias MyProjectWeb.ChallengeView

  def render("index.json", %{challenges: challenges}) do
    %{data: render_many(challenges, ChallengeView, "challenge.json")}
  end

  def render("show.json", %{challenge: challenge}) do
    %{data: render_one(challenge, ChallengeView, "challenge.json")}
  end

  def render("challenge.json", %{challenge: challenge}) do
    %{id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      response: challenge.response,
      chat_id: challenge.chat_id}
  end
end
