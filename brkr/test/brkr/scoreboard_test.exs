defmodule Brkr.ScoreboardTest do
  use Brkr.DataCase

  alias Brkr.Scoreboard

  describe "high_scores" do
    alias Brkr.Scoreboard.HighScore

    import Brkr.ScoreboardFixtures

    @invalid_attrs %{initials: nil, start_time: nil, stop_time: nil}

    test "list_high_scores/0 returns all high_scores" do
      high_score = high_score_fixture()
      assert Scoreboard.list_high_scores() == [high_score]
    end

    test "get_high_score!/1 returns the high_score with given id" do
      high_score = high_score_fixture()
      assert Scoreboard.get_high_score!(high_score.id) == high_score
    end

    test "create_high_score/1 with valid data creates a high_score" do
      valid_attrs = %{initials: "some initials", start_time: ~N[2025-07-24 16:23:00], stop_time: ~N[2025-07-24 16:23:00]}

      assert {:ok, %HighScore{} = high_score} = Scoreboard.create_high_score(valid_attrs)
      assert high_score.initials == "some initials"
      assert high_score.start_time == ~N[2025-07-24 16:23:00]
      assert high_score.stop_time == ~N[2025-07-24 16:23:00]
    end

    test "create_high_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scoreboard.create_high_score(@invalid_attrs)
    end

    test "update_high_score/2 with valid data updates the high_score" do
      high_score = high_score_fixture()
      update_attrs = %{initials: "some updated initials", start_time: ~N[2025-07-25 16:23:00], stop_time: ~N[2025-07-25 16:23:00]}

      assert {:ok, %HighScore{} = high_score} = Scoreboard.update_high_score(high_score, update_attrs)
      assert high_score.initials == "some updated initials"
      assert high_score.start_time == ~N[2025-07-25 16:23:00]
      assert high_score.stop_time == ~N[2025-07-25 16:23:00]
    end

    test "update_high_score/2 with invalid data returns error changeset" do
      high_score = high_score_fixture()
      assert {:error, %Ecto.Changeset{}} = Scoreboard.update_high_score(high_score, @invalid_attrs)
      assert high_score == Scoreboard.get_high_score!(high_score.id)
    end

    test "delete_high_score/1 deletes the high_score" do
      high_score = high_score_fixture()
      assert {:ok, %HighScore{}} = Scoreboard.delete_high_score(high_score)
      assert_raise Ecto.NoResultsError, fn -> Scoreboard.get_high_score!(high_score.id) end
    end

    test "change_high_score/1 returns a high_score changeset" do
      high_score = high_score_fixture()
      assert %Ecto.Changeset{} = Scoreboard.change_high_score(high_score)
    end
  end
end
