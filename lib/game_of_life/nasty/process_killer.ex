defmodule GameOfLife.Nasty.ProcessKiller do
  alias GameOfLife.Nasty

  @spec kill({String.t, pid}) :: String.t
  def kill({name, pid}) do
    Process.exit(pid, :kill)
    Nasty.format(name)
  end
end
