defmodule MyProject.RoomMember do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "room_members" do
    field :name, :string
    field :room_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(room_member, attrs) do
    room_member
    |> cast(attrs, [:room_id, :name])
    |> validate_required([:room_id, :name])
  end
end
