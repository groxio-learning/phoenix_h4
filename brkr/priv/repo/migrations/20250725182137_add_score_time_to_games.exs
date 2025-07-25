defmodule Brkr.Repo.Migrations.AddScoreTimeToGames do
  use Ecto.Migration

  def change do
    alter table(:high_scores) do
      add :score_time, :integer   
    end
  end
end
