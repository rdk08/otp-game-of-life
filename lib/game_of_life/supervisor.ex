defmodule GameOfLife.Supervisor do
  use Supervisor

  # API

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Callbacks

  def init(:ok) do
    opts = Application.get_all_env(:game_of_life)

    children = [
      supervisor(GameOfLife.Cell.Supervisor, []),
      supervisor(GameOfLife.Universe.Supervisor, [opts]),
      supervisor(GameOfLife.Output.Supervisor, []),
      supervisor(GameOfLife.Simulation.Supervisor, [opts]),
      supervisor(GameOfLife.Nasty.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
