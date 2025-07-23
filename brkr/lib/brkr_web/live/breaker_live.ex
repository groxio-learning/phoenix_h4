defmodule BrkrWeb.BreakerLive do
  use BrkrWeb, :live_view
  alias Brkr.Move
  alias Brkr.Game

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, move: Move.new())
    game = Game.new()
    socket = assign(socket, game: game)
    socket = assign(socket, show: Game.show(game))
    {:ok, socket}
  end

  @impl true
  def handle_event("add-move", %{"element" => element}, socket) do
    move = socket.assigns.move |> Move.add(String.to_integer(element))
    {:noreply, assign(socket, move: move)}
  end

  def handle_event("remove-move", _, socket) do
    move = socket.assigns.move |> Move.remove()
    {:noreply, assign(socket, move: move)}
  end

  def handle_event("submit", _, socket) do
    move = socket.assigns.move
    game = socket.assigns.game |> Game.make_guess(move)
    socket = assign(socket, game: game)
    socket = assign(socket, show: Game.show(game))
    {:noreply, assign(socket, move: Move.new())}
  end
end
