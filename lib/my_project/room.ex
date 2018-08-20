defmodule MyProject.Room do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :title, :string
    field :local_room_id, Ecto.UUID

    has_many(:room_members, MyProject.RoomMember, references: :local_room_id, foreign_key: :room_id)
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
