defmodule Summer.CounterDemo do
  @moduledoc """
  Demo module to showcase the CounterService functionality.
  """

  def run_demo do
    IO.puts("=== Summer Counter Service Demo ===\n")

    # Start a counter service
    IO.puts("1. Starting counter service with initial value '0'")
    pid = Summer.CounterService.start("0")
    IO.puts("   Counter PID: #{inspect(pid)}")
    IO.puts("   Initial value: #{Summer.CounterService.get_value(pid)}")
    IO.puts("   HTML representation: #{Summer.CounterService.show(pid)}\n")

    # Increment operations
    IO.puts("2. Performing increment operations")
    Enum.each(1..3, fn i ->
      new_value = Summer.CounterService.increment(pid)
      IO.puts("   Increment #{i}: #{new_value}")
    end)
    IO.puts("   Current value: #{Summer.CounterService.get_value(pid)}")
    IO.puts("   HTML representation: #{Summer.CounterService.show(pid)}\n")

    # Decrement operations
    IO.puts("3. Performing decrement operations")
    Enum.each(1..2, fn i ->
      new_value = Summer.CounterService.decrement(pid)
      IO.puts("   Decrement #{i}: #{new_value}")
    end)
    IO.puts("   Final value: #{Summer.CounterService.get_value(pid)}")
    IO.puts("   HTML representation: #{Summer.CounterService.show(pid)}\n")

    # Multiple counters demo
    IO.puts("4. Running multiple independent counters")
    pid1 = Summer.CounterService.start("100")
    pid2 = Summer.CounterService.start("-10")
    
    IO.puts("   Counter 1 initial value: #{Summer.CounterService.get_value(pid1)}")
    IO.puts("   Counter 2 initial value: #{Summer.CounterService.get_value(pid2)}")
    
    Summer.CounterService.increment(pid1)
    Summer.CounterService.decrement(pid2)
    
    IO.puts("   Counter 1 after increment: #{Summer.CounterService.get_value(pid1)}")
    IO.puts("   Counter 2 after decrement: #{Summer.CounterService.get_value(pid2)}\n")

    # Clean up
    IO.puts("5. Stopping all counter services")
    Summer.CounterService.stop(pid)
    Summer.CounterService.stop(pid1)
    Summer.CounterService.stop(pid2)
    IO.puts("   All counters stopped\n")

    IO.puts("=== Demo Complete ===")
  end

  def interactive_demo do
    IO.puts("=== Interactive Counter Service ===")
    IO.puts("Commands: inc, dec, show, value, stop")
    
    pid = Summer.CounterService.start("0")
    IO.puts("Counter started with value 0")
    
    interactive_loop(pid)
  end

  defp interactive_loop(pid) do
    command = IO.gets("Enter command: ") |> String.trim()
    
    case command do
      "inc" ->
        new_value = Summer.CounterService.increment(pid)
        IO.puts("Incremented to: #{new_value}")
        interactive_loop(pid)
        
      "dec" ->
        new_value = Summer.CounterService.decrement(pid)
        IO.puts("Decremented to: #{new_value}")
        interactive_loop(pid)
        
      "show" ->
        html = Summer.CounterService.show(pid)
        IO.puts("HTML: #{html}")
        interactive_loop(pid)
        
      "value" ->
        value = Summer.CounterService.get_value(pid)
        IO.puts("Current value: #{value}")
        interactive_loop(pid)
        
      "stop" ->
        Summer.CounterService.stop(pid)
        IO.puts("Counter stopped. Goodbye!")
        
      _ ->
        IO.puts("Unknown command. Available: inc, dec, show, value, stop")
        interactive_loop(pid)
    end
  end
end
