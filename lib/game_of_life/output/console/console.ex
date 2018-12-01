defmodule GameOfLife.Output.Console do
  alias GameOfLife.Output.Board

  @env Mix.env()

  @spec draw_board(%Board{}) :: String.t() | :ok
  def draw_board(board) do
    clear(@env)

    board
    |> representation
    |> draw(@env)
  end

  defp clear(env) do
    if IO.ANSI.enabled?() and env != :test do
      IO.write([IO.ANSI.home(), IO.ANSI.clear()])
    else
      :noop
    end
  end

  defp representation(%Board{rows: rows}) do
    rows
    |> Enum.map(&row_representation/1)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp row_representation(row) do
    row
    |> Enum.map(&cell_representation/1)
    |> Enum.join(" ")
  end

  defp cell_representation(:dead), do: " "
  defp cell_representation(:alive), do: "■"

  @spec draw_text(String.t()) :: String.t() | :ok
  def draw_text(text) do
    text
    |> draw(@env)
  end

  defp draw(string, :test), do: string
  defp draw(string, _), do: IO.puts(string)
end
