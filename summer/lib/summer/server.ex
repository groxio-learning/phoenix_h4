defmodule Summer.Server do
  use GenServer

  alias Summer.Counter

  # Callbacks

  @impl true
  def init(input) do
    count = Counter.new(input)
    {:ok, count}
  end

  @impl true
  def handle_call(:show, _from, count) do
    current_count = Counter.show(count)
    {:reply, current_count, count}
  end

  @impl true
  def handle_cast(:inc, count) do
    current_count = Counter.inc(count)
    {:noreply, current_count}
  end

  @impl true
  def handle_cast(:dec, count) do
    current_count = Counter.dec(count)
    {:noreply, current_count}
  end
end
