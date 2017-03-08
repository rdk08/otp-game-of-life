defmodule GameOfLife.Cell.Supervisor do
  use Supervisor

  alias GameOfLife.Cell

  @name __MODULE__
  @supervisor_opts strategy: :simple_one_for_one,
                   max_restarts: 25,
                   max_seconds: 1

  @type key :: {integer, integer}

  # API

  def start_link(name \\ @name) do
    Supervisor.start_link(__MODULE__, :ok, name: name)
  end

  @spec start_child(pid | atom, key, {:dead|:alive, list}) :: {:ok, pid} | {:error, any}
  def start_child(pid \\ @name, key, initial_state) do
    Supervisor.start_child(pid, [key, initial_state])
  end

  # Callbacks

  def init(:ok) do
    supervise([worker(Cell.Server, [])], @supervisor_opts)
  end
end
