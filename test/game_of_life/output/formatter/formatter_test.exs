defmodule GameOfLife.Output.FormatterTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Output.{Board, Formatter}

  test "formats universe state snapshot into a list of drawable rows" do
    input = %{
      snapshot: %{
        {0, 0} => :dead,
        {1, 0} => :alive,
        {2, 0} => :dead,
        {0, 1} => :dead,
        {1, 1} => :dead,
        {2, 1} => :alive,
        {0, 2} => :alive,
        {1, 2} => :alive,
        {2, 2} => :alive
      }
    }

    output = Formatter.format(input.snapshot)

    expected_output = %Board{
      rows: [
        [:dead, :alive, :dead],
        [:dead, :dead, :alive],
        [:alive, :alive, :alive]
      ]
    }

    assert output == expected_output
  end
end
