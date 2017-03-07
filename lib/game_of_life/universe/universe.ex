defmodule GameOfLife.Universe do
  alias __MODULE__, as: Universe

  defstruct cells: [],
            dimensions: {0, 0}

  @type t :: %Universe{
              cells: list(tuple),
              dimensions: {integer, integer}}

  @spec initialize({integer, integer}) :: t
  def initialize(dimensions) do
    %Universe{cells: generate_cells(dimensions), dimensions: dimensions}
  end

  defp generate_cells({columns, rows}) do
    for row <- 0..rows-1,
        column <- 0..columns-1,
    do: {column, row}
  end

  @spec get_neighbours(t, {integer, integer}) :: list({integer, integer})
  def get_neighbours(%Universe{}=universe, key) do
    key_diffs()
    |> Enum.reject(&self_key/1)
    |> Enum.map(&neighbour(&1, key))
    |> Enum.reject(&outside_universe?(&1, universe))
  end

  defp key_diffs do
    for row_diff <- [-1, 0, 1],
        column_diff <- [-1, 0, 1],
    do: {row_diff, column_diff}
  end

  defp self_key(diff), do: diff == {0, 0}

  defp neighbour({column_diff, row_diff}, {column, row}) do
    {column-column_diff, row-row_diff}
  end

  defp outside_universe?({column, row}, %Universe{dimensions: dimensions}) do
    {columns, rows} = dimensions
    {max_column, max_row} = {columns-1, rows-1}
    {min_column, min_row} = {0, 0}
    column > max_column or column < min_column or row > max_row or row < min_row
  end
end
