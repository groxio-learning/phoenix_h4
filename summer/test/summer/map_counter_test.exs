defmodule Summer.MapCounterTest do
  use ExUnit.Case
  doctest Summer.MapCounter

  alias Summer.MapCounter

    describe "new/1" do
        test "converts positive string numbers to integers" do
            assert MapCounter.new(%{count: "5"}) == %{count: 5}
            assert MapCounter.new(%{count: "42"}) == %{count: 42}
            assert MapCounter.new(%{count: "100"}) == %{count: 100}
            assert MapCounter.new(%{count: nil}) == %{count: nil}
        end
    end

    describe "inc/1" do
        test "increments positive integers" do
            assert MapCounter.inc(%{count: 5}) == %{count: 6}
            assert MapCounter.inc(%{count: 42}) == %{count: 43}
            assert MapCounter.inc(%{count: 100}) == %{count: 101}
        end
    end

    describe "dec/1" do
        test "decrements positive integers" do
            assert MapCounter.dec(%{count: 5}) == %{count: 4}
            assert MapCounter.dec(%{count: 42}) == %{count: 41}
            assert MapCounter.dec(%{count: 100}) == %{count: 99}
        end
    end

    describe "show/1" do
        test "wraps positive integers in paragraph tags" do
            assert MapCounter.show(%{count: 5}) == "<p>5</p>"
            assert MapCounter.show(%{count: 42}) == "<p>42</p>"
            assert MapCounter.show(%{count: 100}) == "<p>100</p>"
        end
    end

    describe "integration/1" do
        test "all functions work together" do
            expect = "<p>8</p>"
            actual = MapCounter.new(%{count: "7"})
                     |> MapCounter.inc()
                     |> MapCounter.inc()
                     |> MapCounter.dec()
                     |> MapCounter.show()

            assert actual == expect
        end
    end
end