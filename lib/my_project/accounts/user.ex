defmodule MyProject.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
      |> cast(attrs, [:first_name, :last_name, :email, :password])
      |> validate_required([:first_name, :last_name, :email])
      |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    IO.inspect current_changeset
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Argon2.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end
end
