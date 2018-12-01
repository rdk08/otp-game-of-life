defmodule GameOfLife.Simulation.ServerTest do
  use ExUnit.Case

  import GameOfLife.Test.Support.Functions, only: [random_atom: 0]
  alias GameOfLife.{Cell, Simulation, Universe}
  alias GameOfLife.Output.{Formatter, Console}

  setup do
    universe_opts = [
      dimensions: {3, 3},
      alive_cells: [{0, 1}, {1, 1}, {2, 1}]
    ]

    {:ok, cell_supervisor} = Cell.Supervisor.start_link(random_atom())
    universe = Universe.Initializer.initialize(universe_opts, cell_supervisor)
    {:ok, _} = Universe.Server.start_link(universe)
    {:ok, _} = Formatter.Server.start_link()
    {:ok, _} = Console.Server.start_link()
    {:ok, pid} = Simulation.Server.start_link(random_atom())
    {:ok, pid: pid}
  end

  @tag :integration
  test "runs single generation of Game Of Life", %{pid: pid} do
    Simulation.Server.run_generation(pid)
    :timer.sleep(250)
    output = Universe.Server.snapshot()

    expected_output = %{
      {0, 0} => :dead,
      {1, 0} => :alive,
      {2, 0} => :dead,
      {0, 1} => :dead,
      {1, 1} => :alive,
      {2, 1} => :dead,
      {0, 2} => :dead,
      {1, 2} => :alive,
      {2, 2} => :dead
    }

    assert output == expected_output
  end
end
