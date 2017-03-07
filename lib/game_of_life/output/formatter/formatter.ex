defmodule GameOfLife.Output.Formatter do
  alias GameOfLife.Output.Board

  @doc """
  Formats universe state snapshot into a board (list of drawable rows).
  """
  @spec format(map) :: %Board{}
  def format(snapshot) do
    snapshot
    |> Enum.group_by(&group_cells_by_row/1)
    |> Enum.sort(&sort_by_row/2)
    |> Enum.map(&extract_cells/1)
    |> Enum.map(&sort_row/1)
    |> to_board_struct
  end

  defp group_cells_by_row(cell) do
    {{_column, row}, _state} = cell
    row
  end

  defp sort_by_row({row1, _}, {row2, _}), do: row1 < row2

  defp extract_cells({_row_num, cells}), do: cells

  defp sort_row(row) do
    row
    |> Enum.sort(&sort_by_column/2)
    |> Enum.map(&extract_state/1)
  end

  defp sort_by_column({{col1, _}, _}, {{col2, _}, _}), do: col1 < col2

  defp extract_state({{_, _}, state}), do: state

  defp to_board_struct(rows) do
    %Board{rows: rows}
  end
end
