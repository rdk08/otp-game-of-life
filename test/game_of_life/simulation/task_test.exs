defmodule GameOfLife.Simulation.TaskTest do
  use ExUnit.Case

  alias GameOfLife.{Cell, Simulation, Universe}
  alias GameOfLife.Output.{Formatter, Console}

  setup do
    universe_opts = [
      dimensions: {5, 5},
      alive_cells: [{1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}]
    ]
    simulation_opts = [
      generations: 8,
      sleep: 0,
      nasty_mode: false,
    ]
    {:ok, cell_supervisor} = Cell.Supervisor.start_link
    universe = Universe.Initializer.initialize(universe_opts, cell_supervisor)
    {:ok, _} = Universe.Server.start_link(universe)
    {:ok, _} = Formatter.Server.start_link
    {:ok, _} = Console.Server.start_link
    {:ok, _} = Simulation.State.start_link(simulation_opts)
    {:ok, _} = Simulation.Server.start_link
    {:ok, simulation_opts: simulation_opts}
  end

  @tag :integration
  test "runs Game Of Life simulation", %{simulation_opts: opts} do
    Simulation.Task.start_link(opts)
    :timer.sleep(250)
    output = Universe.Server.snapshot
    expected_output = %{
      {0, 0} => :dead, {1, 0} => :dead, {2, 0} => :dead, {3, 0} => :dead, {4, 0} => :dead,
      {0, 1} => :dead, {1, 1} => :dead, {2, 1} => :dead, {3, 1} => :dead, {4, 1} => :dead,
      {0, 2} => :dead, {1, 2} => :dead, {2, 2} => :dead, {3, 2} => :alive, {4, 2} => :dead,
      {0, 3} => :dead, {1, 3} => :dead, {2, 3} => :dead, {3, 3} => :dead, {4, 3} => :alive,
      {0, 4} => :dead, {1, 4} => :dead, {2, 4} => :alive, {3, 4} => :alive, {4, 4} => :alive,
    }
    assert output == expected_output
    assert Simulation.State.simulation_ended?
  end
end
