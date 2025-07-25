defmodule Brkr.Scoreboard.HighScore do
  use Ecto.Schema

  import Ecto.Changeset
  alias Brkr.Accounts.User

  schema "high_scores" do
    field :initials, :string
    field :start_time, :naive_datetime
    field :stop_time, :naive_datetime
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(high_score, attrs) do
    high_score
    |> cast(attrs, [:user_id, :initials, :start_time, :stop_time])
    |> validate_required([:user_id, :initials, :start_time, :stop_time])
  end
end
