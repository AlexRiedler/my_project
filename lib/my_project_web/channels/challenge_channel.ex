defmodule MyProjectWeb.ChallengeChannel do
  use MyProjectWeb, :channel

  alias MyProject.{Challenges}

  def join("challenges:" <> challenge_id, _params, socket) do
    challenge = Challenges.get_challenge!(challenge_id)
    socket = assign(socket, :challenge, challenge)
    response = %{challenge: challenge}
    {:ok, response, socket}
  end

  def handle_in("response:update", %{"response" => codeResponse, "user_id" => user_id}, socket) do
    case Challenges.update_challenge(socket.assigns.challenge, codeResponse) do
      {:ok, challenge} ->
        broadcast! socket, "response:updated", %{challenge: challenge}
        {:noreply, socket}
      {:error, changeset} ->
        {:reply, {:error, %{error: "Error updating challenge with response"}}, socket}
    end
  end
end
