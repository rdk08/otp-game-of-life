defmodule GameOfLife.Simulation.StateTest do
  use ExUnit.Case, async: true

  import GameOfLife.Test.Support.Functions, only: [random_atom: 0]
  alias GameOfLife.Simulation

  setup do
    simulation_opts = [generations: 10]
    name = random_atom()
    {:ok, _} = Simulation.State.start_link(name, simulation_opts)
    {:ok, name: name}
  end

  test "keeps remaining generations count", %{name: name} do
    output = Simulation.State.remaining_generations(name)
    expected_output = 10
    assert output == expected_output
  end

  test "returns information if simulation has ended", %{name: name} do
    refute Simulation.State.simulation_ended?(name)
    for _ <- 1..10, do: Simulation.State.next_generation(name)
    assert Simulation.State.simulation_ended?(name)
  end
end
