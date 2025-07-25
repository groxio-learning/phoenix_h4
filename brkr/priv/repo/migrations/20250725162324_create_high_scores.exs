defmodule Brkr.Repo.Migrations.CreateHighScores do
  use Ecto.Migration

  def change do
    create table(:high_scores) do
      add :initials, :string
      add :start_time, :naive_datetime
      add :stop_time, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:high_scores, [:user_id])
  end
end
