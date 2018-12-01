defmodule GameOfLife.UniverseTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Universe

  test "default values" do
    output = %Universe{}
    expected_output = %Universe{cells: [], dimensions: {0, 0}}
    assert output == expected_output
  end

  test "initializes universe" do
    input = %{
      dimensions: {3, 3}
    }

    output = Universe.initialize(input.dimensions)

    expected_output = %Universe{
      cells: [
        {0, 0},
        {1, 0},
        {2, 0},
        {0, 1},
        {1, 1},
        {2, 1},
        {0, 2},
        {1, 2},
        {2, 2}
      ],
      dimensions: {3, 3}
    }

    assert output == expected_output
  end

  test "calculates neighbours for given cell" do
    dimensions = {3, 3}

    input = %{
      universe: Universe.initialize(dimensions),
      keys: [
        {0, 0},
        {1, 1},
        {2, 1}
      ]
    }

    output = Enum.map(input.keys, &Universe.get_neighbours(input.universe, &1))

    expected_output = [
      [{1, 1}, {1, 0}, {0, 1}],
      [{2, 2}, {2, 1}, {2, 0}, {1, 2}, {1, 0}, {0, 2}, {0, 1}, {0, 0}],
      [{2, 2}, {2, 0}, {1, 2}, {1, 1}, {1, 0}]
    ]

    assert output == expected_output
  end
end
