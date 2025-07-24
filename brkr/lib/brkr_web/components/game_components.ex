defmodule BrkrWeb.GameComponents do
  use Phoenix.Component

  alias Brkr.Game

  ## TODO:
  ## 1. redirect on game over []
  ## 2. show answer on lost []
  ## 3. Start over button on game over []
  ## 4. Show welcome email

  attr(:game, :any, required: true)

  def board(assigns) do
    ~H"""
    <pre>
    {Game.show(@game)}
    </pre>
    """
  end

  attr(:value, :string, required: true)

  def move_button(assigns) do
    ~H"""
    <button phx-click="add-move" phx-value-element={@value} class={move_button_class(@value)}>
      {@value}
    </button>
    """
  end

  defp move_button_class(value) do
    color_class =
      case value do
        1 -> "bg-red-500"
        2 -> "bg-blue-500"
        3 -> "bg-green-500"
        4 -> "bg-yellow-400"
        5 -> "bg-purple-500"
        6 -> "bg-black text-white"
        _ -> "bg-gray-300"
      end

    "w-8 h-8 #{color_class} rounded-full"
  end

  def score(assigns) do
    red = assigns.score.red
    white = assigns.score.white
    colors = List.duplicate(:red, red) ++ List.duplicate(:white, white)
    assigns = assign(assigns, :colors, colors)

    ~H"""
    <%= for color <- @colors do %>
      <.score_tag color={color} />
    <% end %>
    """
  end

  def row(assigns) do
    ~H"""
    <div class="flex items-center gap-4 mb-4">
      <.guess guess={@guess} />
      <.score score={@score} />
    </div>
    """
  end

  defp score_tag(assigns) do
    score_color_class =
      case assigns.color do
        :red -> "bg-black"
        :white -> "bg-red-200"
        _ -> "bg-gray-300"
      end

    assigns = assign(assigns, :class, score_color_class)

    ~H"""
    <p class={"inline-flex w-4 h-4 rounded-full #{@score_color_class}"} />
    """
  end

  def guess_move(assigns) do
    ~H"""
    <.move_tag value={@move} />
    """
  end

  def guess(assigns) do
    ~H"""
    <div class="flex gap-2">
      <%= for value <- @guess do %>
        <.move_tag value={value} />
      <% end %>
    </div>
    """
  end

  def status(assigns) do
    ~H"""
    <div class="mb-2 text-[25px]">{Game.status(assigns.game)}</div>
    """
  end

  defp move_tag(assigns) do
    ~H"""
    <span class={move_button_class(@value)} />
    """
  end
end
