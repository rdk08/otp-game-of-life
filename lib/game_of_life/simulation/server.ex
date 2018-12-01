defmodule GameOfLife.Simulation.Server do
  use GenServer

  alias GameOfLife.Universe
  alias GameOfLife.Output.{Formatter, Console}

  @name __MODULE__

  # API

  def start_link(name \\ @name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @spec run_generation(pid | atom) :: :ok
  def run_generation(pid \\ @name) do
    GenServer.call(pid, {:run_generation})
  end

  # Callbacks

  def init(:ok) do
    {:ok, nil}
  end

  def handle_call({:run_generation}, _, _) do
    Universe.Server.snapshot()
    |> Formatter.Server.format()
    |> Console.Server.draw_board()

    Universe.Server.next_generation()
    {:reply, :ok, nil}
  end
end
