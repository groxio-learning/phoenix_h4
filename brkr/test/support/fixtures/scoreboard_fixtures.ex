defmodule Brkr.ScoreboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Brkr.Scoreboard` context.
  """

  @doc """
  Generate a high_score.
  """
  def high_score_fixture(attrs \\ %{}) do
    {:ok, high_score} =
      attrs
      |> Enum.into(%{
        initials: "some initials",
        start_time: ~N[2025-07-24 16:23:00],
        stop_time: ~N[2025-07-24 16:23:00]
      })
      |> Brkr.Scoreboard.create_high_score()

    high_score
  end
end
