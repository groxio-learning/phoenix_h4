defmodule Summer.Service do

  alias Summer.Counter

  def start(input) do
    count = Counter.new(input)
    spawn(fn -> loop(count) end)
  end

  def increment(pid) do
    send(pid, :increment)
  end

  def decrement(pid) do
    send(pid, :decrement)
  end

  def show(pid) do
    send(pid, {:show, self()})
    receive do
      html -> html
    end
  end

  def loop(count) do
    count
    |> listen()
    |> loop()
  end

  def listen(count) do
    receive do
      :increment ->
       Counter.inc(count)
      :decrement ->
        Counter.dec(count)
      {:show, caller_pid} ->
        send(caller_pid, Counter.show(count))
        count
      _ ->
        IO.puts("Unknown message received")
       count
    end
  end
end
