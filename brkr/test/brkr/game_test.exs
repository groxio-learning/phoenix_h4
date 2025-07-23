defmodule Brkr.GameTest do
  use ExUnit.Case
  alias Brkr.Game

  test "new/0 initializes a new game with scrambled answer" do
    game = Game.new()
    assert length(game.answer) == 4
    assert Enum.all?(game.answer, &(&1 in 1..6))
    assert game.guesses == []
    assert game.scores == []
  end

  test "new/1 initializes a new game with a given secret" do
    secret = [6, 5, 4, 3]
    game = Game.new(secret)
    assert game.answer == secret
    assert game.guesses == []
    assert game.scores == []
  end

  test "scramble/1 generates a new secret for the game" do
    game = Game.new([1, 2, 3, 4])
    scrambled_game = Game.scramble(game)
    assert scrambled_game.answer != [1, 2, 3, 4]
    assert length(scrambled_game.answer) == 4
    assert Enum.all?(scrambled_game.answer, &(&1 in 1..6))
  end

  test "make_guess/2 adds a guess to the game" do
    game = Game.new([1, 2, 3, 4])
    guess = [4, 3, 2, 1]
    updated_game = Game.make_guess(game, guess)
    assert updated_game.guesses == [guess]
  end
end
