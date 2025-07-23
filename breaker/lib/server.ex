defmodule Breaker.Server do
  use GenServer

  alias Breaker.Game

  ## API
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def make_guess(name, guess) do
    GenServer.call(name, {:make_guess, guess})
    |> IO.puts()
  end

  ## Callbacks
  @impl true
  def init(name) do
    IO.puts( "Starting game for #{name}")
    game = Game.new()
    {:ok, game}
  end

  @impl true
  def handle_call({:make_guess, guess}, _from, game) do
      new_game = Game.make_guess(game, guess)
      {:reply, Game.show(new_game), new_game}
  end
end
