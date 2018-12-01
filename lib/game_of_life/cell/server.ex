defmodule GameOfLife.Cell.Server do
  use GenServer

  alias GameOfLife.Cell

  # API

  @type key :: {integer, integer}

  @spec start_link(key, {:dead | :alive, list}) :: {:ok, pid} | {:error, any}
  def start_link(key, {initial_state, neighbours}) do
    GenServer.start_link(__MODULE__, {initial_state, neighbours}, name: via_tuple(key))
  end

  @spec state(key) :: %Cell{}
  def state(key) do
    GenServer.call(via_tuple(key), {:state})
  end

  @spec broadcast_state(key) :: :ok
  def broadcast_state(key) do
    GenServer.call(via_tuple(key), {:broadcast_state})
  end

  @spec add_neighbour(key, key) :: no_return
  def add_neighbour(key, neighbour_key) do
    GenServer.cast(via_tuple(key), {:add_neighbour, neighbour_key})
  end

  @spec send_state(key, %Cell{}) :: no_return
  def send_state(key, state) do
    GenServer.cast(via_tuple(key), {:send_state, state})
  end

  @spec next_generation(key) :: no_return
  def next_generation(key) do
    GenServer.cast(via_tuple(key), {:next_generation})
  end

  # Callbacks

  def init({initial_state, neighbours}) do
    {:ok, %Cell{state: initial_state, neighbours: neighbours}}
  end

  def handle_call({:state}, _, cell) do
    {:reply, Cell.state(cell), cell}
  end

  def handle_call({:broadcast_state}, _, cell) do
    cell.neighbours
    |> Enum.map(&Cell.Server.send_state(&1, cell.state))

    {:reply, :ok, cell}
  end

  def handle_cast({:add_neighbour, neighbour}, cell) do
    {:noreply, Cell.add_neighbour(cell, neighbour)}
  end

  def handle_cast({:send_state, state}, cell) do
    {:noreply, Cell.add_neighbour_state(cell, state)}
  end

  def handle_cast({:next_generation}, cell) do
    {:noreply, Cell.next_generation(cell)}
  end

  # Process registry

  def whereis(key) do
    :gproc.whereis_name({:n, :l, {:cell_server, key}})
  end

  defp via_tuple(key) do
    {:via, :gproc, {:n, :l, {:cell_server, key}}}
  end
end
