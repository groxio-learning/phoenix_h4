defmodule Summer.CounterService do
  @moduledoc """
  A counter service that uses spawn, send, and receive to provide
  a stateful counter service built on top of the Summer.Counter functional core.

  Supports subscriptions where clients can receive automatic notifications
  when the counter value changes.
  """

  @doc """
  Starts a new counter service process with an initial value.
  Returns the PID of the spawned process.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> is_pid(pid)
      true
  """
  def start(initial_value_string) do
    initial_value = Summer.Counter.new(initial_value_string)
    spawn(__MODULE__, :loop, [initial_value, []])
  end

  @doc """
  The main loop that handles messages for the counter service.
  This function runs indefinitely, maintaining the counter state and subscriber list.
  """
  def loop(current_value, subscribers) do
    receive do
      {:increment, caller_pid} ->
        new_value = Summer.Counter.inc(current_value)
        send(caller_pid, {:ok, new_value})
        notify_subscribers(subscribers, {:value_changed, new_value})
        loop(new_value, subscribers)

      {:decrement, caller_pid} ->
        new_value = Summer.Counter.dec(current_value)
        send(caller_pid, {:ok, new_value})
        notify_subscribers(subscribers, {:value_changed, new_value})
        loop(new_value, subscribers)

      {:get_value, caller_pid} ->
        send(caller_pid, {:ok, current_value})
        loop(current_value, subscribers)

      {:show, caller_pid} ->
        html_value = Summer.Counter.show(current_value)
        send(caller_pid, {:ok, html_value})
        loop(current_value, subscribers)

      {:subscribe, caller_pid} ->
        new_subscribers = [caller_pid | subscribers]
        send(caller_pid, {:ok, :subscribed, current_value})
        loop(current_value, new_subscribers)

      {:unsubscribe, caller_pid} ->
        new_subscribers = List.delete(subscribers, caller_pid)
        send(caller_pid, {:ok, :unsubscribed})
        loop(current_value, new_subscribers)

      {:stop, caller_pid} ->
        send(caller_pid, {:ok, :stopped})
        # Exit the loop and terminate the process
        :ok

      unknown_message ->
        IO.puts("Unknown message received: #{inspect(unknown_message)}")
        loop(current_value, subscribers)
    end
  end

  @doc """
  Increments the counter by 1.
  Returns the new value.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.increment(pid)
      6
  """
  def increment(counter_pid) do
    send(counter_pid, {:increment, self()})
    receive do
      {:ok, new_value} -> new_value
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Decrements the counter by 1.
  Returns the new value.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.decrement(pid)
      4
  """
  def decrement(counter_pid) do
    send(counter_pid, {:decrement, self()})
    receive do
      {:ok, new_value} -> new_value
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Gets the current value of the counter.
  Returns the current value.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.get_value(pid)
      5
  """
  def get_value(counter_pid) do
    send(counter_pid, {:get_value, self()})
    receive do
      {:ok, value} -> value
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Gets the HTML representation of the counter value.
  Returns the HTML string.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.show(pid)
      "<p>5</p>"
  """
  def show(counter_pid) do
    send(counter_pid, {:show, self()})
    receive do
      {:ok, html_value} -> html_value
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Stops the counter service.
  Returns :ok when the service is stopped.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.stop(pid)
      :stopped
  """
  def stop(counter_pid) do
    send(counter_pid, {:stop, self()})
    receive do
      {:ok, :stopped} -> :stopped
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Subscribe to counter value changes.
  The subscriber will receive {:value_changed, new_value} messages.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.subscribe(pid)
      {:subscribed, 5}
  """
  def subscribe(counter_pid) do
    send(counter_pid, {:subscribe, self()})
    receive do
      {:ok, :subscribed, current_value} -> {:subscribed, current_value}
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Unsubscribe from counter value changes.

  ## Examples

      iex> pid = Summer.CounterService.start("5")
      iex> Summer.CounterService.subscribe(pid)
      iex> Summer.CounterService.unsubscribe(pid)
      :unsubscribed
  """
  def unsubscribe(counter_pid) do
    send(counter_pid, {:unsubscribe, self()})
    receive do
      {:ok, :unsubscribed} -> :unsubscribed
    after
      5000 -> {:error, :timeout}
    end
  end

  # Private helper function to notify all subscribers
  defp notify_subscribers(subscribers, message) do
    Enum.each(subscribers, fn subscriber_pid ->
      send(subscriber_pid, message)
    end)
  end
end
