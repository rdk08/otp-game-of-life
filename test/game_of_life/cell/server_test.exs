defmodule GameOfLife.Cell.ServerTest do
  use ExUnit.Case, async: true

  import GameOfLife.Test.Support.Functions, only: [times: 2, random_key: 0]
  alias GameOfLife.Cell

  setup do
    key = random_key()
    {:ok, _} = Cell.Server.start_link(key, {:alive, []})
    {:ok, key: key}
  end

  test "returns cell state", %{key: key} do
    output = Cell.Server.state(key)
    expected_output = %Cell{
      state: :alive,
      neighbours: [],
      neighbour_states: []
    }
    assert output == expected_output
  end

  test "adds neighbour", %{key: key} do
    [neighbour_key|_] = start_neighbours(1, :dead)
    Cell.Server.add_neighbour(key, neighbour_key)
    output = Cell.Server.state(key).neighbours
    expected_output = [neighbour_key]
    assert output == expected_output
  end

  test "sends state to neighbour", %{key: key} do
    Cell.Server.send_state(key, :dead)
    output = Cell.Server.state(key).neighbour_states
    expected_output = [:dead]
    assert output == expected_output
  end

  test "broadcasts cell state to all neighbours", %{key: key} do
    neighbour_keys = start_neighbours(8, :dead)
    Enum.map(neighbour_keys, &Cell.Server.add_neighbour(key, &1))

    Cell.Server.broadcast_state(key)
    output =
      neighbour_keys
      |> Enum.map(&Cell.Server.state(&1).neighbour_states)
      |> List.flatten
    expected_output = ~w(alive alive alive alive alive alive alive alive)a
    assert output == expected_output
  end

  test "moves cell into next generation", %{key: key} do
    states = times(3, :alive) ++ times(5, :dead)
    Enum.map(states, &Cell.Server.send_state(key, &1))

    Cell.Server.next_generation(key)
    output = Cell.Server.state(key)
    expected_output = %Cell{state: :alive, neighbour_states: [], neighbours: []}
    assert output == expected_output
  end

  # helper function

  defp start_neighbours(num, initial_state) do
    for _ <- 1..num do
      key = random_key()
      {:ok, _} = Cell.Server.start_link(key, {initial_state, []})
      key
    end
  end
end
