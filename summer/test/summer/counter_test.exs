defmodule Summer.CounterTest do
  use ExUnit.Case
  doctest Summer.Counter

  alias Summer.Counter

  describe "new/1" do
    test "converts positive string numbers to integers" do
      assert Counter.new("5") == 5
      assert Counter.new("42") == 42
      assert Counter.new("100") == 100
    end

    test "converts negative string numbers to integers" do
      assert Counter.new("-5") == -5
      assert Counter.new("-42") == -42
      assert Counter.new("-100") == -100
    end

    test "converts zero string to integer" do
      assert Counter.new("0") == 0
    end

    test "handles large numbers" do
      assert Counter.new("999999") == 999999
      assert Counter.new("-999999") == -999999
    end

    test "raises error for invalid string input" do
      assert_raise ArgumentError, fn ->
        Counter.new("not_a_number")
      end

      assert_raise ArgumentError, fn ->
        Counter.new("12.5")
      end

      assert_raise ArgumentError, fn ->
        Counter.new("")
      end
    end

    test "raises error for non-string input" do
      assert_raise FunctionClauseError, fn ->
        Counter.new(123)
      end

      assert_raise FunctionClauseError, fn ->
        Counter.new(nil)
      end
    end
  end

  describe "inc/1" do
    test "increments positive integers" do
      assert Counter.inc(5) == 6
      assert Counter.inc(42) == 43
      assert Counter.inc(100) == 101
    end

    test "increments negative integers" do
      assert Counter.inc(-5) == -4
      assert Counter.inc(-1) == 0
      assert Counter.inc(-100) == -99
    end

    test "increments zero" do
      assert Counter.inc(0) == 1
    end

    test "handles large numbers" do
      assert Counter.inc(999999) == 1000000
      assert Counter.inc(-999999) == -999998
    end

    test "raises error for non-integer input" do
      assert_raise FunctionClauseError, fn ->
        Counter.inc("5")
      end

      assert_raise FunctionClauseError, fn ->
        Counter.inc(5.5)
      end

      assert_raise FunctionClauseError, fn ->
        Counter.inc(nil)
      end
    end
  end

  describe "dec/1" do
    test "decrements positive integers" do
      assert Counter.dec(5) == 4
      assert Counter.dec(42) == 41
      assert Counter.dec(100) == 99
    end

    test "decrements negative integers" do
      assert Counter.dec(-5) == -6
      assert Counter.dec(-100) == -101
    end

    test "decrements zero" do
      assert Counter.dec(0) == -1
    end

    test "decrements one to zero" do
      assert Counter.dec(1) == 0
    end

    test "handles large numbers" do
      assert Counter.dec(999999) == 999998
      assert Counter.dec(-999999) == -1000000
    end

    test "raises error for non-integer input" do
      assert_raise FunctionClauseError, fn ->
        Counter.dec("5")
      end

      assert_raise FunctionClauseError, fn ->
        Counter.dec(5.5)
      end

      assert_raise FunctionClauseError, fn ->
        Counter.dec(nil)
      end
    end
  end

  describe "show/1" do
    test "wraps positive integers in paragraph tags" do
      assert Counter.show(5) == "<p>5</p>"
      assert Counter.show(42) == "<p>42</p>"
      assert Counter.show(100) == "<p>100</p>"
    end

    test "wraps negative integers in paragraph tags" do
      assert Counter.show(-5) == "<p>-5</p>"
      assert Counter.show(-42) == "<p>-42</p>"
      assert Counter.show(-100) == "<p>-100</p>"
    end

    test "wraps zero in paragraph tags" do
      assert Counter.show(0) == "<p>0</p>"
    end

    test "handles large numbers" do
      assert Counter.show(999999) == "<p>999999</p>"
      assert Counter.show(-999999) == "<p>-999999</p>"
    end

    test "raises error for non-integer input" do
      assert_raise FunctionClauseError, fn ->
        Counter.show("5")
      end

      assert_raise FunctionClauseError, fn ->
        Counter.show(5.5)
      end

      assert_raise FunctionClauseError, fn ->
        Counter.show(nil)
      end
    end
  end

  describe "integration tests" do
    test "complete counter workflow" do
      # Start with a string, convert to integer
      counter = Counter.new("10")
      assert counter == 10

      # Increment it
      incremented = Counter.inc(counter)
      assert incremented == 11

      # Decrement from the incremented value
      decremented = Counter.dec(incremented)
      assert decremented == 10

      # Show the final result
      result = Counter.show(decremented)
      assert result == "<p>10</p>"
    end

    test "chaining operations" do
      result = "5"
               |> Counter.new()
               |> Counter.inc()
               |> Counter.inc()
               |> Counter.dec()
               |> Counter.show()

      assert result == "<p>6</p>"
    end

    test "working with negative starting values" do
      result = "-3"
               |> Counter.new()
               |> Counter.inc()
               |> Counter.inc()
               |> Counter.inc()
               |> Counter.show()

      assert result == "<p>0</p>"
    end
  end
end
