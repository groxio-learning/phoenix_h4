defmodule Brkr.Score do
  defstruct red: 0,
            white: 0

  def new(answer, guess) do
    red =
      answer
      |> Enum.zip(guess)
      |> Enum.count(fn {a, g} -> a == g end)

    total = length(answer)

    missing = length(guess -- answer)

    white = total - red - missing
    %__MODULE__{red: red, white: white}
  end

  def show(%{red: red, white: white}) do
    # RRWW
    converted_red = String.duplicate(~S{R}, red)
    converted_white = String.duplicate(~S{W}, white)

    "#{converted_red}#{converted_white}"
  end
end
