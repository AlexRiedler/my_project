defmodule MyProjectWeb.Session do
  alias MyProject.Accounts.{User}
  alias MyProject.{Repo}

  def authenticate(%{"email" => email, "password" => password}) do
    case Repo.get_by(User, email: email) do
      nil ->
        :error

      user ->
        case verify_password(password, user.encrypted_password) do
          true ->
            {:ok, user}

          _ ->
            :error
        end
    end
  end

  defp verify_password(password, pw_hash) do
    Comeonin.Argon2.checkpw(password, pw_hash)
  end
end
