defmodule BrkrWeb.BreakerLive do
  use BrkrWeb, :live_view
  import BrkrWeb.GameComponents
  alias Brkr.Move
  alias Brkr.Game

  @impl true
  def mount(_params, session, socket) do
    game = Game.new()
    IO.inspect(Map.keys(session))
    {
      :ok,
      socket
      |> assign(move: Move.new())
      |> assign(game: game)
      |> assign(email: socket.assigns.current_user.email)
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
    move =
      socket.assigns.move
      |> Enum.reverse()

    game =
      socket.assigns.game
      |> Game.make_guess(move)



    updated_socket =
      socket
      |> assign(game: game)
      |> assign(move: Move.new())

    case Game.status(game) do
    :won ->
      Phoenix.LiveView.redirect(updated_socket, to: ~p"/won")
    :lost ->
      Phoenix.LiveView.redirect(updated_socket, to: ~p"/lost")
      _ ->
       updated_socket
    end

  end
end
