defmodule Breaker.Score do
  defstruct  red: 0,
    white: 0

  def new(answer, guess) do
    red =
      answer
      |> Enum.zip(guess)
      |> Enum.count(fn {a, g} -> a == g  end)

    total = length(answer)

    missing = length(guess -- answer)

    white = (total - red) - missing
    %__MODULE__{red: red, white: white}
  end
end
