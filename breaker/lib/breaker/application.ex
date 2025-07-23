defmodule Breaker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
    %{id: 1, start: {Breaker.Server, :start_link, [:superman]}},
    %{id: 2, start: {Breaker.Server, :start_link, [:antman]}},
    %{id: 3, start: {Breaker.Server, :start_link, [:flash]}},
    %{id: 4, start: {Breaker.Server, :start_link, [:ironman]}}
      # Starts a worker by calling: Breaker.Worker.start_link(arg)
      # {Breaker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Breaker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
