defmodule GameOfLife.Universe.InitializerTest do
  use ExUnit.Case

  import GameOfLife.Test.Support.Functions, only: [random_atom: 0]
  alias GameOfLife.{Cell, Universe}

  setup do
    cell_supervisor = random_atom()
    {:ok, _} = Cell.Supervisor.start_link(cell_supervisor)
    {:ok, cell_supervisor: cell_supervisor}
  end

  @tag :integration
  test "initializes universe with random state",
       %{cell_supervisor: cell_supervisor} do
    input = %{
      opts: [
        dimensions: {3, 3},
        alive_cells: :random
      ],
      cell_supervisor: cell_supervisor
    }

    output = Universe.Initializer.initialize(input.opts, input.cell_supervisor)
    assert %Universe{cells: cells, dimensions: {3, 3}} = output
    assert Enum.all?(cells, &Process.alive?(Cell.Server.whereis(&1)))
    assert Enum.count(cells) == 9
  end

  @tag :integration
  test "initializes universe with predefined state",
       %{cell_supervisor: cell_supervisor} do
    input = %{
      opts: [
        dimensions: {3, 3},
        alive_cells: [{0, 1}, {1, 1}, {2, 2}]
      ],
      cell_supervisor: cell_supervisor
    }

    universe = Universe.Initializer.initialize(input.opts, input.cell_supervisor)
    {:ok, pid} = Universe.Server.start_link(universe)
    output = Universe.Server.snapshot(pid)

    expected_output = %{
      {0, 0} => :dead,
      {1, 0} => :dead,
      {2, 0} => :dead,
      {0, 1} => :alive,
      {1, 1} => :alive,
      {2, 1} => :dead,
      {0, 2} => :dead,
      {1, 2} => :dead,
      {2, 2} => :alive
    }

    assert output == expected_output
    assert %Universe{cells: cells, dimensions: {3, 3}} = universe
    assert Enum.all?(cells, &Process.alive?(Cell.Server.whereis(&1)))
    assert Enum.count(cells) == 9
  end
end
