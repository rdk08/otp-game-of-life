defmodule GameOfLife.Output.Formatter.Server do
  use GenServer

  alias GameOfLife.Output.{Board, Formatter}

  @name __MODULE__

  # API

  def start_link(name \\ @name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @spec format(pid | atom, map) :: %Board{}
  def format(pid \\ @name, snapshot) do
    GenServer.call(pid, {:format, snapshot})
  end

  # Callbacks

  def init(:ok) do
    {:ok, nil}
  end

  def handle_call({:format, snapshot}, _, _) do
    {:reply, Formatter.format(snapshot), nil}
  end
end
