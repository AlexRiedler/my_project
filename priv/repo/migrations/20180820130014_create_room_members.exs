defmodule MyProject.Repo.Migrations.CreateRoomMembers do
  use Ecto.Migration

  def change do
    create table(:room_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :room_id, :uuid
      add :name, :string

      timestamps()
    end

  end
end
