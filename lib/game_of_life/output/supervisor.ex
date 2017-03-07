defmodule GameOfLife.Output.Supervisor do
  use Supervisor

  @name __MODULE__
  @supervisor_opts strategy: :one_for_one,
                   max_restarts: 25,
                   max_seconds: 1
  # API

  def start_link(name \\ @name) do
    Supervisor.start_link(__MODULE__, :ok, name: name)
  end

  # Callbacks

  def init(:ok) do
    children = [
      worker(GameOfLife.Output.Console.Server, []),
      worker(GameOfLife.Output.Formatter.Server, [])
    ]
    supervise(children, @supervisor_opts)
  end
end
