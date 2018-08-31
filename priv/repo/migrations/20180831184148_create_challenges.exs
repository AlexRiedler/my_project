defmodule MyProject.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :response, :string
      add :chat_id, :uuid

      timestamps()
    end

  end
end
