defmodule GameOfLife.Cell do
  alias GameOfLife.Cell

  defstruct state: :dead,
            neighbours: [],
            neighbour_states: []

  @type t :: %Cell{state: :alive | :dead, neighbours: list, neighbour_states: list}

  @spec state(t) :: t
  def state(cell), do: cell

  @spec update(t, map) :: t
  def update(cell, changes), do: Map.merge(cell, changes)

  @spec add_neighbour(t, {integer, integer}) :: t
  def add_neighbour(cell, neighbour) do
    changes = %{neighbours: [neighbour | cell.neighbours]}
    Cell.update(cell, changes)
  end

  @spec add_neighbour_state(t, :dead | :alive) :: t
  def add_neighbour_state(cell, neighbour_state) do
    changes = %{neighbour_states: [neighbour_state | cell.neighbour_states]}
    Cell.update(cell, changes)
  end

  @spec next_generation(t) :: t
  def next_generation(%Cell{neighbour_states: neighbour_states, state: state} = cell) do
    changes =
      neighbour_states
      |> Enum.filter(&alive?/1)
      |> Enum.count()
      |> determine_state(state)
      |> clear_neighbour_states

    Cell.update(cell, changes)
  end

  defp alive?(state), do: state == :alive

  defp determine_state(alive_neighbours, :alive) when alive_neighbours < 2 do
    %{state: :dead}
  end

  defp determine_state(alive_neighbours, :alive) when alive_neighbours > 3 do
    %{state: :dead}
  end

  defp determine_state(alive_neighbours, :dead) when alive_neighbours == 3 do
    %{state: :alive}
  end

  defp determine_state(_, :alive), do: %{state: :alive}
  defp determine_state(_, :dead), do: %{state: :dead}

  defp clear_neighbour_states(changes) do
    Map.merge(changes, %{neighbour_states: []})
  end
end
