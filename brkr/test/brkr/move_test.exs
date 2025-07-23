defmodule Brkr.MoveTest do
  use ExUnit.Case
  alias Brkr.Move

  test "new/0 returns an empty list" do
    assert Move.new() == []
  end

  test "add/2 adds an element to the move list" do
    move = Move.new()
    updated_move = Move.add(move, :element1)
    assert updated_move == [:element1]

    updated_move = Move.add(updated_move, :element2)
    assert updated_move == [:element2, :element1]
  end

  test "remove/1 removes the first element from the move list" do
    move = Move.new()
    move = Move.add(move, :element1)
    move = Move.add(move, :element2)

    updated_move = Move.remove(move)
    assert updated_move == [:element1]

    updated_move = Move.remove(updated_move)
    assert updated_move == []
  end
end
