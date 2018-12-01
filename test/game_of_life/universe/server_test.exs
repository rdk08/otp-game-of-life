defmodule GameOfLife.Universe.ServerTest do
  use ExUnit.Case, async: true

  import GameOfLife.Test.Support.Functions, only: [random_atom: 0]
  alias GameOfLife.{Cell, Universe}

  setup do
    cell_supervisor = random_atom()
    {:ok, _} = Cell.Supervisor.start_link(cell_supervisor)

    opts = [
      dimensions: {3, 3},
      alive_cells: [{2, 2}]
    ]

    {:ok, cell_supervisor: cell_supervisor, opts: opts}
  end

  @tag :integration
  test "makes state snapshot", %{cell_supervisor: cell_supervisor, opts: opts} do
    process_name = random_atom()
    universe = Universe.Initializer.initialize(opts, cell_supervisor)
    {:ok, _} = Universe.Server.start_link(process_name, universe)

    output = Universe.Server.snapshot(process_name)

    expected_output = %{
      {0, 0} => :dead,
      {1, 0} => :dead,
      {2, 0} => :dead,
      {0, 1} => :dead,
      {1, 1} => :dead,
      {2, 1} => :dead,
      {0, 2} => :dead,
      {1, 2} => :dead,
      {2, 2} => :alive
    }

    assert output == expected_output
  end

  @tag :integration
  test "moves into next generation", %{cell_supervisor: cell_supervisor, opts: opts} do
    process_name = random_atom()
    universe = Universe.Initializer.initialize(opts, cell_supervisor)
    {:ok, _} = Universe.Server.start_link(process_name, universe)

    Universe.Server.next_generation(process_name)
    output = Universe.Server.snapshot(process_name)

    expected_output = %{
      {0, 0} => :dead,
      {1, 0} => :dead,
      {2, 0} => :dead,
      {0, 1} => :dead,
      {1, 1} => :dead,
      {2, 1} => :dead,
      {0, 2} => :dead,
      {1, 2} => :dead,
      {2, 2} => :dead
    }

    assert output == expected_output
  end
end
