defmodule MyProjectWeb.ChallengePresence do
  use Phoenix.Presence, otp_app: :my_project,
    pubsub_server: MyProject.PubSub

  def track_user_join(socket, user) do
    MyProjectWeb.ChallengePresence.track(socket, user.id, %{
      typing: false,
      first_name: user.first_name,
      last_name: user.last_name,
      user_id: user.id
    })
  end
end
