defmodule MyProject.Challenges.Challenge do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:id, :title, :description, :response]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "challenges" do
    field(:title, :string)
    field(:description, :string)
    field(:response, :string)
    field(:chat_id, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(challenge, attrs) do
    challenge
    |> cast(attrs, [:title, :description, :response, :chat_id])
    |> validate_required([:title, :description])
  end
end
