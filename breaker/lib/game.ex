defmodule Breaker.Game do
  alias Breaker.Score

  defstruct answer: [1, 2, 3, 4],
            guesses: [],
            scores: []

  @attempts 8

  def new() do
    %__MODULE__{}
    |> scramble()
  end

  def new(secret) do
    %__MODULE__{
      answer: secret,
      guesses: [],
      scores: []
    }
  end

  def scramble(game) do
    secret = Enum.take_random(1..6, 4)
    %{game | answer: secret}
  end

  def make_guess(game, guess) do
    %{game | guesses: [guess | game.guesses]}
    |> score()
  end

  def score(%{answer: answer, guesses: [guess | _guesses], scores: scores} = game) do
    score = Score.new(answer, guess)
    %{game | scores: [score | scores]}
  end

  def show(%{scores: scores, guesses: guesses} = game) do
    # 1, 2, 3, 4 RRWW

    board =
      Enum.zip(guesses, scores)
      |> Enum.map(&print_row/1)
      |> Enum.join("\n")

    answer = "? ? ? ?"

    status = status(game)

    """
    #{answer}

    #{board}

    #{status}
    """
  end

  defp print_row({guess, score}) do
    guess_str = Enum.join(guess, ~S{ })
    score_str = Score.show(score)

    "| #{guess_str} | #{score_str}"
  end

  defp status(%{scores: [%{red: 4} | _scores]}) do
    "You won!"
  end

  defp status(game) do
    if length(game.guesses) >= @attempts do
      "You lost"
    else
      "Make a guess"
    end
  end
end
