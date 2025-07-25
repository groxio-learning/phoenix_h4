defmodule Brkr.Repo.Migrations.AddInitialToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :initials, :string   
    end
  end
end
