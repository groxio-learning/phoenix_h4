defmodule Brkr.Move do
  def new do
    []
  end

  def add(move, element) do
    [element | move]
  end

  def remove([_element | move]) do
    move
  end
end
