defmodule GameOfLife.ChaosMonkey.Supervisor do
  use Supervisor

  @name __MODULE__

  # API

  def start_link(name \\ @name) do
    Supervisor.start_link(__MODULE__, :ok, name: name)
  end

  # Callbacks

  def init(:ok) do
    children = [
      worker(GameOfLife.ChaosMonkey.Server, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
