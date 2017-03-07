defmodule GameOfLife.Output.ConsoleTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Output.{Board, Console}

  test "draws empty board in a console" do
    input = %{
      board: %Board{
        rows: [
          [:dead, :dead, :dead],
          [:dead, :dead, :dead],
          [:dead, :dead, :dead],
        ]
      }
    }
    output = Console.draw_board(input.board)
    expected_output =
      """
           
           
           
      """
    assert output == expected_output
  end

  test "draws board in a console" do
    input = %{
      board: %Board{
        rows: [
          [:dead, :alive, :dead],
          [:dead, :dead, :alive],
          [:alive, :alive, :alive],
        ]
      }
    }
    output = Console.draw_board(input.board)
    expected_output =
      """
        ■  
          ■
      ■ ■ ■
      """
    assert output == expected_output
  end

  test "draws text in console" do
    input = %{
      text: "Sample text"
    }
    output = Console.draw_text(input.text)
    expected_output = "Sample text"
    assert output == expected_output
  end
end
