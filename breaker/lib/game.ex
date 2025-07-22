defmodule Breaker.Game do 
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
    end

    def score(game) do

    end

    def show(game) do

    end
end