defmodule Breaker.Game do
    alias Breaker.Score

    defstruct answer: [1, 2, 3, 4],
              guesses: [],
              scores: []

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
        |> show()
    end

    def score(%{answer: answer, guesses: [guess | _guesses], scores: scores } = game) do
        score = Score.new(answer, guess)
        %{game | scores: [score | scores]}
    end

  def show(%{scores: [%{red: red, white: white} | _], guesses: guesses} = game) do
    max_allowed_guesses = 2
    number_of_guesses = Enum.count(guesses)

    cond do
        red == 4 ->
        "<p>You win!</p>"

        number_of_guesses >= max_allowed_guesses ->
        "<p>Game over!</p>"

        true ->
            IO.puts("<p>reds: #{red} whites: #{white}</p>")
            game
    end

  end
end
