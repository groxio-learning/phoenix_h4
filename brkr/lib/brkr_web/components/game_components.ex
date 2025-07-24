defmodule BrkrWeb.GameComponents do
  use Phoenix.Component

  alias Brkr.Game

  attr(:game, :any, required: true)

  def board(assigns) do
    ~H"""
    <pre>
    {Game.show(@game)}
    </pre>
    """
  end
end
