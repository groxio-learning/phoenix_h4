defmodule Summer.CounterSubscriber do
  @moduledoc """
  A demo module showing how to subscribe to counter value changes
  and receive notifications automatically.
  """

  @doc """
  Creates a subscriber process that listens for counter changes.
  Returns the PID of the subscriber process.
  """
  def start_subscriber(name \\ "Subscriber") do
    spawn(__MODULE__, :subscriber_loop, [name])
  end

  @doc """
  The main loop for a subscriber process.
  Handles incoming counter value change notifications.
  """
  def subscriber_loop(name) do
    receive do
      {:value_changed, new_value} ->
        IO.puts("#{name} received notification: Counter changed to #{new_value}")
        subscriber_loop(name)
        
      {:stop} ->
        IO.puts("#{name} stopping...")
        :ok
        
      other ->
        IO.puts("#{name} received unexpected message: #{inspect(other)}")
        subscriber_loop(name)
    end
  end

  @doc """
  Demonstrates multiple subscribers receiving counter updates.
  """
  def demo_multiple_subscribers do
    IO.puts("=== Multiple Subscribers Demo ===\n")
    
    # Start counter service
    counter_pid = Summer.CounterService.start("0")
    IO.puts("Counter started with value 0\n")
    
    # Start multiple subscriber processes
    subscriber1 = start_subscriber("Alice")
    subscriber2 = start_subscriber("Bob") 
    subscriber3 = start_subscriber("Charlie")
    
    # Subscribe all of them to the counter
    IO.puts("Subscribing Alice, Bob, and Charlie to counter updates...")
    
    # Use spawn to subscribe each in their own process context
    spawn(fn ->
      Summer.CounterService.subscribe(counter_pid)
      subscriber_loop("Alice")
    end)
    
    spawn(fn ->
      Summer.CounterService.subscribe(counter_pid)
      subscriber_loop("Bob")
    end)
    
    spawn(fn ->
      Summer.CounterService.subscribe(counter_pid)
      subscriber_loop("Charlie")
    end)
    
    # Give subscribers time to subscribe
    Process.sleep(100)
    
    IO.puts("\nPerforming counter operations (all subscribers will be notified):\n")
    
    # Perform some operations
    IO.puts("1. Incrementing counter...")
    Summer.CounterService.increment(counter_pid)
    Process.sleep(100)
    
    IO.puts("2. Incrementing counter again...")
    Summer.CounterService.increment(counter_pid)
    Process.sleep(100)
    
    IO.puts("3. Decrementing counter...")
    Summer.CounterService.decrement(counter_pid)
    Process.sleep(100)
    
    IO.puts("4. Incrementing one more time...")
    Summer.CounterService.increment(counter_pid)
    Process.sleep(100)
    
    # Clean up
    Summer.CounterService.stop(counter_pid)
    IO.puts("\nDemo complete!")
  end

  @doc """
  Shows how a single subscriber can listen for changes.
  """
  def demo_single_subscriber do
    IO.puts("=== Single Subscriber Demo ===\n")
    
    # Start counter and subscribe
    counter_pid = Summer.CounterService.start("10")
    {:subscribed, initial_value} = Summer.CounterService.subscribe(counter_pid)
    
    IO.puts("Subscribed to counter. Initial value: #{initial_value}")
    IO.puts("Listening for changes (will timeout after 10 seconds)...\n")
    
    # Spawn a task to modify the counter
    spawn(fn ->
      Process.sleep(1000)
      IO.puts("Incrementing counter...")
      Summer.CounterService.increment(counter_pid)
      
      Process.sleep(1000)
      IO.puts("Decrementing counter...")
      Summer.CounterService.decrement(counter_pid)
      
      Process.sleep(1000)
      IO.puts("Incrementing counter again...")
      Summer.CounterService.increment(counter_pid)
    end)
    
    # Listen for changes
    listen_for_changes(3)
    
    # Clean up
    Summer.CounterService.unsubscribe(counter_pid)
    Summer.CounterService.stop(counter_pid)
    IO.puts("\nSingle subscriber demo complete!")
  end

  defp listen_for_changes(0) do
    IO.puts("Stopped listening for changes.")
  end

  defp listen_for_changes(remaining) do
    receive do
      {:value_changed, new_value} ->
        IO.puts("Received notification: Counter is now #{new_value}")
        listen_for_changes(remaining - 1)
    after
      5000 ->
        IO.puts("No more changes received (timeout)")
    end
  end

  @doc """
  Interactive demo where you can manually trigger changes and see notifications.
  """
  def interactive_demo do
    IO.puts("=== Interactive Subscriber Demo ===")
    IO.puts("Starting counter and subscribing...")
    
    counter_pid = Summer.CounterService.start("0")
    {:subscribed, initial_value} = Summer.CounterService.subscribe(counter_pid)
    
    IO.puts("Subscribed! Initial value: #{initial_value}")
    IO.puts("Commands: inc, dec, value, stop")
    IO.puts("You'll see notifications when the counter changes!\n")
    
    interactive_loop(counter_pid)
  end

  defp interactive_loop(counter_pid) do
    # Check for any pending notifications first
    receive do
      {:value_changed, new_value} ->
        IO.puts("🔔 NOTIFICATION: Counter changed to #{new_value}")
        interactive_loop(counter_pid)
    after
      0 -> 
        # No pending notifications, proceed with user input
        command = IO.gets("Enter command: ") |> String.trim()
        
        case command do
          "inc" ->
            new_value = Summer.CounterService.increment(counter_pid)
            IO.puts("Incremented to: #{new_value}")
            interactive_loop(counter_pid)
            
          "dec" ->
            new_value = Summer.CounterService.decrement(counter_pid)
            IO.puts("Decremented to: #{new_value}")
            interactive_loop(counter_pid)
            
          "value" ->
            value = Summer.CounterService.get_value(counter_pid)
            IO.puts("Current value: #{value}")
            interactive_loop(counter_pid)
            
          "stop" ->
            Summer.CounterService.unsubscribe(counter_pid)
            Summer.CounterService.stop(counter_pid)
            IO.puts("Unsubscribed and stopped. Goodbye!")
            
          _ ->
            IO.puts("Unknown command. Available: inc, dec, value, stop")
            interactive_loop(counter_pid)
        end
    end
  end
end
