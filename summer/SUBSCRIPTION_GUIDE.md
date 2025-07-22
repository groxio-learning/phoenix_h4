# How to Receive Counter Values as a Subscribed User

This document explains how to use the subscription feature of the Counter Service to automatically receive notifications when counter values change.

## Basic Subscription Pattern

### 1. Simple Subscription

```elixir
# Start a counter service
counter_pid = Summer.CounterService.start("0")

# Subscribe to receive notifications
{:subscribed, initial_value} = Summer.CounterService.subscribe(counter_pid)
# Returns: {:subscribed, 0}

# Now you'll automatically receive {:value_changed, new_value} messages
# when someone modifies the counter

# Listen for changes
receive do
  {:value_changed, new_value} ->
    IO.puts("Counter changed to: #{new_value}")
end
```

### 2. Listening Loop

```elixir
defmodule MySubscriber do
  def listen_for_changes do
    receive do
      {:value_changed, new_value} ->
        IO.puts("Received update: #{new_value}")
        # Continue listening
        listen_for_changes()
    after
      5000 ->
        IO.puts("No updates in 5 seconds")
    end
  end
end
```

## Practical Examples

### Example 1: Real-time Dashboard

```elixir
defmodule Dashboard do
  def start(counter_pid) do
    Summer.CounterService.subscribe(counter_pid)
    display_loop()
  end
  
  defp display_loop do
    receive do
      {:value_changed, new_value} ->
        update_display(new_value)
        display_loop()
    end
  end
  
  defp update_display(value) do
    IO.puts("Dashboard: Current count is #{value}")
  end
end
```

### Example 2: Multiple Subscribers

```elixir
# Start counter
counter_pid = Summer.CounterService.start("10")

# Create multiple subscriber processes
logger = spawn(fn ->
  Summer.CounterService.subscribe(counter_pid)
  loop_with_name("Logger")
end)

monitor = spawn(fn ->
  Summer.CounterService.subscribe(counter_pid)
  loop_with_name("Monitor")
end)

# When you change the counter, both processes get notified
Summer.CounterService.increment(counter_pid)
# Output:
# Logger received notification: Counter changed to 11
# Monitor received notification: Counter changed to 11
```

## Message Format

When you subscribe, you'll receive messages in this format:

```elixir
{:value_changed, new_value}
```

Where `new_value` is the integer value of the counter after the change.

## Complete Usage Flow

```elixir
# 1. Start the counter service
counter_pid = Summer.CounterService.start("5")

# 2. Subscribe to changes
{:subscribed, initial_value} = Summer.CounterService.subscribe(counter_pid)

# 3. Set up a listener (in a separate process if needed)
listener_pid = spawn(fn ->
  receive do
    {:value_changed, value} -> 
      IO.puts("Counter is now: #{value}")
  end
end)

# 4. Make changes - subscribers get notified automatically
Summer.CounterService.increment(counter_pid)  # Notifications sent
Summer.CounterService.decrement(counter_pid)  # Notifications sent

# 5. Unsubscribe when done
Summer.CounterService.unsubscribe(counter_pid)

# 6. Stop the service
Summer.CounterService.stop(counter_pid)
```

## Interactive Demo

You can run the interactive demo to see subscriptions in action:

```elixir
# In IEx
Summer.CounterSubscriber.interactive_demo()
```

This will start a counter, subscribe you to changes, and let you see notifications in real-time as you make changes.

## Multiple Subscribers Demo

```elixir
# In IEx
Summer.CounterSubscriber.demo_multiple_subscribers()
```

This demonstrates how multiple processes can all subscribe to the same counter and receive notifications simultaneously.
