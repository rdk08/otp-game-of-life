defmodule GameOfLife.Universe.Server do
  use GenServer

  alias GameOfLife.{Cell, Universe}

  @name __MODULE__
  @type t :: %Universe{}

  # API

  @spec start_link(atom, t) :: {:ok, pid} | {:error | any}
  def start_link(name \\ @name, universe) do
    GenServer.start_link(__MODULE__, universe, name: name)
  end

  @spec snapshot(pid | atom) :: map
  def snapshot(pid \\ @name) do
    GenServer.call(pid, {:snapshot})
  end

  @spec next_generation(pid | atom) :: :ok
  def next_generation(pid \\ @name) do
    GenServer.call(pid, {:next_generation})
  end

  # Callbacks

  def init(universe) do
    {:ok, universe}
  end

  def handle_call({:snapshot}, _from, universe) do
    snapshot =
      universe.cells
      |> Enum.into(%{}, &{&1, Cell.Server.state(&1).state})

    {:reply, snapshot, universe}
  end

  def handle_call({:next_generation}, _from, universe) do
    Enum.map(universe.cells, &Cell.Server.broadcast_state(&1))
    Enum.map(universe.cells, &Cell.Server.next_generation(&1))
    {:reply, :ok, universe}
  end
end
