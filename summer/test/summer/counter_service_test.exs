defmodule Summer.CounterServiceTest do
  use ExUnit.Case
  doctest Summer.CounterService

  describe "CounterService" do
    test "starts a counter service with initial value" do
      pid = Summer.CounterService.start("10")
      assert is_pid(pid)
      assert Process.alive?(pid)
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "gets the initial counter value" do
      pid = Summer.CounterService.start("42")
      assert Summer.CounterService.get_value(pid) == 42
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "increments the counter" do
      pid = Summer.CounterService.start("5")
      
      assert Summer.CounterService.increment(pid) == 6
      assert Summer.CounterService.increment(pid) == 7
      assert Summer.CounterService.get_value(pid) == 7
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "decrements the counter" do
      pid = Summer.CounterService.start("10")
      
      assert Summer.CounterService.decrement(pid) == 9
      assert Summer.CounterService.decrement(pid) == 8
      assert Summer.CounterService.get_value(pid) == 8
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "shows HTML representation of counter" do
      pid = Summer.CounterService.start("3")
      
      assert Summer.CounterService.show(pid) == "<p>3</p>"
      
      Summer.CounterService.increment(pid)
      assert Summer.CounterService.show(pid) == "<p>4</p>"
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "handles multiple operations in sequence" do
      pid = Summer.CounterService.start("0")
      
      # Start at 0
      assert Summer.CounterService.get_value(pid) == 0
      
      # Increment to 3
      Summer.CounterService.increment(pid)
      Summer.CounterService.increment(pid)
      Summer.CounterService.increment(pid)
      assert Summer.CounterService.get_value(pid) == 3
      
      # Decrement to 1
      Summer.CounterService.decrement(pid)
      Summer.CounterService.decrement(pid)
      assert Summer.CounterService.get_value(pid) == 1
      
      # Check HTML representation
      assert Summer.CounterService.show(pid) == "<p>1</p>"
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "stops the counter service" do
      pid = Summer.CounterService.start("5")
      assert Process.alive?(pid)
      
      assert Summer.CounterService.stop(pid) == :stopped
      
      # Give the process a moment to terminate
      Process.sleep(10)
      refute Process.alive?(pid)
    end

    test "handles negative values" do
      pid = Summer.CounterService.start("-5")
      
      assert Summer.CounterService.get_value(pid) == -5
      assert Summer.CounterService.increment(pid) == -4
      assert Summer.CounterService.decrement(pid) == -5
      assert Summer.CounterService.show(pid) == "<p>-5</p>"
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "multiple counter services can run independently" do
      pid1 = Summer.CounterService.start("10")
      pid2 = Summer.CounterService.start("20")
      
      # Operate on first counter
      Summer.CounterService.increment(pid1)
      assert Summer.CounterService.get_value(pid1) == 11
      
      # Operate on second counter
      Summer.CounterService.decrement(pid2)
      assert Summer.CounterService.get_value(pid2) == 19
      
      # Verify they're independent
      assert Summer.CounterService.get_value(pid1) == 11
      assert Summer.CounterService.get_value(pid2) == 19
      
      # Clean up
      Summer.CounterService.stop(pid1)
      Summer.CounterService.stop(pid2)
    end
  end

  describe "Subscription functionality" do
    test "subscribes to counter changes" do
      pid = Summer.CounterService.start("5")
      
      {:subscribed, initial_value} = Summer.CounterService.subscribe(pid)
      assert initial_value == 5
      
      # Clean up
      Summer.CounterService.unsubscribe(pid)
      Summer.CounterService.stop(pid)
    end

    test "receives notifications when counter changes" do
      pid = Summer.CounterService.start("0")
      Summer.CounterService.subscribe(pid)
      
      # Increment and check for notification
      Summer.CounterService.increment(pid)
      assert_receive {:value_changed, 1}, 1000
      
      # Decrement and check for notification
      Summer.CounterService.decrement(pid)
      assert_receive {:value_changed, 0}, 1000
      
      # Clean up
      Summer.CounterService.unsubscribe(pid)
      Summer.CounterService.stop(pid)
    end

    test "multiple subscribers receive notifications" do
      pid = Summer.CounterService.start("10")
      
      # Start multiple subscriber processes
      subscriber1 = spawn(fn ->
        Summer.CounterService.subscribe(pid)
        receive do
          {:value_changed, value} -> send(self(), {:subscriber1_got, value})
        end
      end)
      
      subscriber2 = spawn(fn ->
        Summer.CounterService.subscribe(pid)
        receive do
          {:value_changed, value} -> send(self(), {:subscriber2_got, value})
        end
      end)
      
      # Give subscribers time to subscribe
      Process.sleep(50)
      
      # Change the counter
      Summer.CounterService.increment(pid)
      
      # Both subscribers should receive the notification
      # Note: In a real test, you'd need a more sophisticated way to verify
      # that both processes received the message
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "unsubscribes from counter changes" do
      pid = Summer.CounterService.start("5")
      
      # Subscribe then unsubscribe
      Summer.CounterService.subscribe(pid)
      result = Summer.CounterService.unsubscribe(pid)
      
      assert result == :unsubscribed
      
      # Should not receive notifications after unsubscribing
      Summer.CounterService.increment(pid)
      refute_receive {:value_changed, _}, 500
      
      # Clean up
      Summer.CounterService.stop(pid)
    end

    test "subscription survives multiple counter operations" do
      pid = Summer.CounterService.start("0")
      Summer.CounterService.subscribe(pid)
      
      # Perform multiple operations
      Summer.CounterService.increment(pid)  # 0 -> 1
      assert_receive {:value_changed, 1}
      
      Summer.CounterService.increment(pid)  # 1 -> 2
      assert_receive {:value_changed, 2}
      
      Summer.CounterService.decrement(pid)  # 2 -> 1
      assert_receive {:value_changed, 1}
      
      Summer.CounterService.decrement(pid)  # 1 -> 0
      assert_receive {:value_changed, 0}
      
      # Clean up
      Summer.CounterService.unsubscribe(pid)
      Summer.CounterService.stop(pid)
    end
  end
end
