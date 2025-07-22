defmodule Summer.MapCounter do
  @moduledoc """
  A counter module that provides basic arithmetic operations and formatting using map.
  """

    def new(%{count: value}) when is_binary(value) do
        %{count: String.to_integer(value)}
    end

    def inc(%{count: value}) when is_integer(value) do
        %{count: value + 1}
    end
    
    def dec(%{count: value}) when is_integer(value) do
        %{count: value - 1}
    end

    def show(%{count: value}) when is_integer(value) do
        "<p>#{value}</p>"
    end
end