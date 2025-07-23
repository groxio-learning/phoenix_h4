defmodule Brkr.ScoreTest do
  use ExUnit.Case
  alias Brkr.Score

  test "new/2 calculates the score correctly" do
    answer = [1, 2, 3, 4]
    guess = [4, 3, 2, 1]
    score = Score.new(answer, guess)

    # Assuming Score.new returns a struct %Brkr.Score{red: correct_positions, white: correct_numbers}
    # Example: 0 correct positions, 4 correct numbers
    assert score == %Brkr.Score{red: 0, white: 4}
  end

  test "new/2 handles no matches" do
    answer = [1, 2, 3, 4]
    guess = [5, 6, 7, 8]
    score = Score.new(answer, guess)
    assert score == %Brkr.Score{red: 0, white: 0}
  end

  test "new/2 handles exact matches" do
    answer = [1, 2, 3, 4]
    guess = [1, 2, 3, 4]
    score = Score.new(answer, guess)
    # Example: 4 correct positions, 0 additional correct numbers
    assert score == %Brkr.Score{red: 4, white: 0}
  end
end
