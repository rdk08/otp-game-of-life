defmodule GameOfLife.Output.Console.ServerTest do
  use ExUnit.Case, async: true

  import GameOfLife.Test.Support.Functions, only: [random_atom: 0]
  alias GameOfLife.Output.{Board, Console}

  setup do
    {:ok, pid} = Console.Server.start_link(random_atom())
    {:ok, %{pid: pid}}
  end

  test "draws board in a console", %{pid: pid} do
    input = %{
      board: %Board{
        rows: [
          [:dead, :alive, :dead],
          [:dead, :dead, :alive],
          [:alive, :alive, :alive],
        ]
      }
    }
    output = Console.Server.draw_board(pid, input.board)
    expected_output =
      """
        ■  
          ■
      ■ ■ ■
      """
    assert output == expected_output
  end

  test "draws text in a console", %{pid: pid} do
    input = %{
      text: "Sample text"
    }
    output = Console.Server.draw_text(pid, input.text)
    expected_output = "Sample text"
    assert output == expected_output
  end
end
