defmodule GameOfLife.Simulation.Supervisor do
  use Supervisor

  @name __MODULE__
  @supervisor_opts strategy: :one_for_one,
                   max_restarts: 25,
                   max_seconds: 1
  # API

  def start_link(name \\ @name, opts) do
    Supervisor.start_link(__MODULE__, opts, name: name)
  end

  # Callbacks

  def init(opts) do
    simulation_opts = Keyword.take(opts, ~w(generations sleep nasty_mode)a)

    children = [
      worker(GameOfLife.Simulation.State, [simulation_opts]),
      worker(GameOfLife.Simulation.Server, []),
      worker(GameOfLife.Simulation.Task, [simulation_opts], restart: :transient)
    ]

    supervise(children, @supervisor_opts)
  end
end
