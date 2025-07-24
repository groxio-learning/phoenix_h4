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

  attr(:value, :string, required: true)
  def move_button(assigns)do
    ~H"""
      <button
        phx-click="add-move"
        phx-value-element={@value}
        class={move_button_class(@value)}>
        {@value}
      </button>
    """
  end

  defp move_button_class(value) do
    color_class = case value do
      1 -> "bg-red-500"
      2 -> "bg-blue-500"
      3 -> "bg-green-500"
      4 -> "bg-yellow-500"
      5 -> "bg-purple-500"
      6 -> "bg-pink-500"
      _ -> "bg-gray-300 text-black"
    end
    "w-8 h-8 #{color_class} rounded-full"
  end

end
