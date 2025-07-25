defmodule BrkrWeb.HighScoreLive.Index do
  use BrkrWeb, :live_view

  alias Brkr.Scoreboard
  alias Brkr.Scoreboard.HighScore
  import BrkrWeb.GameComponents 

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :high_scores, Scoreboard.list_high_scores())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit High score")
    |> assign(:high_score, Scoreboard.get_high_score!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New High score")
    |> assign(:high_score, %HighScore{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing High scores")
    |> assign(:high_score, nil)
  end

  @impl true
  def handle_info({BrkrWeb.HighScoreLive.FormComponent, {:saved, high_score}}, socket) do
    {:noreply, stream_insert(socket, :high_scores, high_score)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    high_score = Scoreboard.get_high_score!(id)
    {:ok, _} = Scoreboard.delete_high_score(high_score)

    {:noreply, stream_delete(socket, :high_scores, high_score)}
  end
end
