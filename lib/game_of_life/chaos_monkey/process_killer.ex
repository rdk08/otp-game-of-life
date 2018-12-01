defmodule GameOfLife.ChaosMonkey.ProcessKiller do
  alias GameOfLife.ChaosMonkey

  @spec kill({String.t(), pid}) :: String.t()
  def kill({name, pid}) do
    Process.exit(pid, :kill)
    ChaosMonkey.format(name)
  end
end
