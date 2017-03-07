defmodule GameOfLife.Nasty.ProcessPicker do
  alias GameOfLife.{Cell, Universe}

  @spec random(list(atom)) :: {String.t, pid}
  def random(process_pool) do
    name = get_name(process_pool)
    pid = get_pid(name)
    {format(name), pid}
  end

  defp get_name(process_pool) do
    Enum.random(process_pool)
  end

  defp get_pid(GameOfLife.Cell.Server) do
    Universe.Server.snapshot
    |> Map.keys
    |> Enum.random
    |> Cell.Server.whereis
  end
  defp get_pid(name) do
    Process.whereis(name)
  end

  defp format(name) do
    name
    |> Atom.to_string
    |> String.split(".")
    |> Enum.slice(-2..-1)
    |> Enum.join(" ")
  end
end
