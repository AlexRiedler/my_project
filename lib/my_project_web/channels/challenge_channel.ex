defmodule MyProjectWeb.ChallengeChannel do
  use MyProjectWeb, :channel

  alias MyProject.{Challenges}
  alias MyProjectWeb.ChallengePresence

  def join("challenges:" <> challenge_id, _params, socket) do
    challenge = Challenges.get_challenge!(challenge_id)
    socket = assign(socket, :challenge, challenge)
    send(self, {:after_join, challenge})
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

  def handle_info({:after_join, challenge}, socket) do
    ChallengePresence.track_user_join(socket, socket.assigns.current_user)
    push socket, "presence_state", ChallengePresence.list(socket)
    {:noreply, socket}
  end
end
