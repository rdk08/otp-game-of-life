defmodule GameOfLife.Universe.Supervisor do
  use Supervisor

  alias GameOfLife.{Cell, Universe}

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
    universe_opts = Keyword.take(opts, ~w(dimensions alive_cells)a)
    universe = Universe.Initializer.initialize(universe_opts, Cell.Supervisor)

    children = [
      worker(GameOfLife.Universe.Server, [universe])
    ]

    supervise(children, @supervisor_opts)
  end
end
