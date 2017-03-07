defmodule GameOfLife.CellTest do
  use ExUnit.Case, async: true

  import GameOfLife.Test.Support.Functions, only: [times: 2]
  alias GameOfLife.Cell

  test "initial state" do
    cell = %Cell{}
    assert cell.state == :dead
    assert cell.neighbours == []
    assert cell.neighbour_states == []
  end

  test "updates cell" do
    input = %{
      cell: %Cell{
        state: :dead,
        neighbours: [],
        neighbour_states: []
      },
      changes: %{neighbour_states: [:alive]}
    }
    output = Cell.update(input.cell, input.changes)
    expected_output = %Cell{
      state: :dead,
      neighbours: [],
      neighbour_states: [:alive]
    }
    assert output == expected_output
  end

  test "adds information about neighbour state" do
    input = %{
      cell: %Cell{
        state: :dead,
        neighbours: [],
        neighbour_states: []
      },
      neighbour_state: :dead
    }
    output = Cell.add_neighbour_state(input.cell, input.neighbour_state)
    expected_output = %Cell{
      state: :dead,
      neighbours: [],
      neighbour_states: [:dead]
    }
    assert output == expected_output
  end

  test "adds information about neighbour location" do
    input = %{
      cell: %Cell{
        state: :dead,
        neighbours: [],
        neighbour_states: []
      },
      neighbour: {3, 3}
    }
    output = Cell.add_neighbour(input.cell, input.neighbour)
    expected_output = %Cell{
      state: :dead,
      neighbours: [{3, 3}],
      neighbour_states: []
    }
    assert output == expected_output
  end

  test "determines state in new generation (initial: dead)" do
    input = [
      %Cell{state: :dead, neighbour_states: times(8, :dead) ++ times(0, :alive)},
      %Cell{state: :dead, neighbour_states: times(7, :dead) ++ times(1, :alive)},
      %Cell{state: :dead, neighbour_states: times(6, :dead) ++ times(2, :alive)},
      %Cell{state: :dead, neighbour_states: times(5, :dead) ++ times(3, :alive)},
      %Cell{state: :dead, neighbour_states: times(4, :dead) ++ times(4, :alive)},
      %Cell{state: :dead, neighbour_states: times(3, :dead) ++ times(5, :alive)},
      %Cell{state: :dead, neighbour_states: times(2, :dead) ++ times(6, :alive)},
      %Cell{state: :dead, neighbour_states: times(1, :dead) ++ times(7, :alive)},
      %Cell{state: :dead, neighbour_states: times(0, :dead) ++ times(8, :alive)},
    ]
    output =
      input
      |> Enum.map(&Cell.next_generation/1)
      |> Enum.map(&(&1.state))
    expected_output = [
      :dead,
      :dead,
      :dead,
      :alive,
      :dead,
      :dead,
      :dead,
      :dead,
      :dead,
    ]
    assert output == expected_output
  end

  test "determines state in new generation (initial: alive)" do
    input = [
      %Cell{state: :alive, neighbour_states: times(8, :dead) ++ times(0, :alive)},
      %Cell{state: :alive, neighbour_states: times(7, :dead) ++ times(1, :alive)},
      %Cell{state: :alive, neighbour_states: times(6, :dead) ++ times(2, :alive)},
      %Cell{state: :alive, neighbour_states: times(5, :dead) ++ times(3, :alive)},
      %Cell{state: :alive, neighbour_states: times(4, :dead) ++ times(4, :alive)},
      %Cell{state: :alive, neighbour_states: times(3, :dead) ++ times(5, :alive)},
      %Cell{state: :alive, neighbour_states: times(2, :dead) ++ times(6, :alive)},
      %Cell{state: :alive, neighbour_states: times(1, :dead) ++ times(7, :alive)},
      %Cell{state: :alive, neighbour_states: times(0, :dead) ++ times(8, :alive)},
    ]
    output =
      input
      |> Enum.map(&Cell.next_generation/1)
      |> Enum.map(&(&1.state))
    expected_output = [
      :dead,
      :dead,
      :alive,
      :alive,
      :dead,
      :dead,
      :dead,
      :dead,
      :dead,
    ]
    assert output == expected_output
  end
end
