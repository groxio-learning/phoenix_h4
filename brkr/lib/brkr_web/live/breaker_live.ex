defmodule BrkrWeb.BreakerLive do
  use BrkrWeb, :live_view
  alias Brkr.Move
  alias Brkr.Game

  @impl true
  def mount(_params, _session, socket) do
    game = Game.new()

    {
      :ok,
      socket
      |> assign(move: Move.new())
      |> assign(game: game)
      |> assign(show: Game.show(game))
    }
  end

  @impl true
  def handle_event("add-move", %{"element" => element}, socket) do
    move =
      socket.assigns.move
      |> Move.add(String.to_integer(element))

    {:noreply, assign(socket, move: move)}
  end

  def handle_event("remove-move", _, socket) do
    move =
      socket.assigns.move
      |> Move.remove()

    {:noreply, assign(socket, move: move)}
  end

  def handle_event("submit", _, socket) do
    {:noreply, submit(socket)}
  end

  defp submit(socket) do
    move = socket.assigns.move

    game =
      socket.assigns.game
      |> Game.make_guess(move)

    socket =
      socket
      |> assign(game: game)
      |> assign(show: Game.show(game))
      |> assign(move: Move.new())
  end
end
