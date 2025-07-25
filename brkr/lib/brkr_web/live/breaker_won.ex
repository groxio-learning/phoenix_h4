defmodule BrkrWeb.BreakerWon do
  use BrkrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
