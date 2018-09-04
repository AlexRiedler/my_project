defmodule MyProject.Guardian do
  use Guardian, otp_app: :my_project

  alias MyProject.{Repo}
  alias MyProject.Accounts.{User}

  def subject_for_token(resource = %User{}, _claims) do
    {:ok, "User:v1:#{resource.id}"}
  end

  def resource_from_claims(claims) do
    case claims["sub"] do
      "User:v1:" <> id ->
        case Repo.get!(User, id) do
          nil -> {:error, :resource_not_found}
          user -> {:ok, user}
        end

      _ ->
        {:error, :resource_not_found}
    end
  end
end
