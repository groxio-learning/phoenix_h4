defmodule BrkrWeb.HighScoreLive.Show do
  use BrkrWeb, :live_view

  alias Brkr.Scoreboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:high_score, Scoreboard.get_high_score!(id))}
  end

  defp page_title(:show), do: "Show High score"
  defp page_title(:edit), do: "Edit High score"
end
