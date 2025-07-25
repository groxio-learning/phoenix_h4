defmodule BrkrWeb.BreakerLive do
  use BrkrWeb, :live_view
  import BrkrWeb.GameComponents
  alias Brkr.Move
  alias Brkr.Game
  alias Brkr.Scoreboard

  @impl true
  def mount(_params, session, socket) do
    game = Game.new()
    IO.inspect(Map.keys(session))

    {
      :ok,
      socket
      |> assign(move: Move.new())
      |> assign(game: game)
      |> assign(start_time: DateTime.utc_now())
    }
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
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
        process_high_score(updated_socket)
      :lost ->
        updated_socket 
        |> assign(end_time: DateTime.utc_now())
        |> push_patch(to: ~p"/lost")

      _ ->
        updated_socket
    end
  end

  defp process_high_score(updated_socket) do
    end_time = DateTime.utc_now()
    high_score_params = %{
      initials: updated_socket.assigns.current_user.initials,
      start_time: updated_socket.assigns.start_time,
      stop_time: end_time,
      user_id: updated_socket.assigns.current_user.id,
      score_time: NaiveDateTime.diff(end_time, updated_socket.assigns.start_time, :second)
    }
    
    Scoreboard.create_high_score(updated_socket.assigns.current_user, high_score_params)
      updated_socket 
      |> stream(:high_scores, Scoreboard.list_high_scores())
      |> assign(end_time: end_time)
      |> push_patch(to: ~p"/won")
  end
end
