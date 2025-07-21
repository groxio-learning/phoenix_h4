defmodule StructCounterTest do
  use ExUnit.Case
  doctest StructCounter

  test "greets the world" do
    assert StructCounter.hello() == :world
  end
end
