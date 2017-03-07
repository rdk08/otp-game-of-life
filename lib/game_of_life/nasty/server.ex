defmodule GameOfLife.Nasty.Server do
  use GenServer

  alias GameOfLife.{Nasty, Output}

  @name __MODULE__
  @mess_up_frequency 0.2
  @process_pool [GameOfLife.Output.Console.Server,
                 GameOfLife.Output.Formatter.Server,
                 GameOfLife.Cell.Server,
                 GameOfLife.Universe.Server,
                 GameOfLife.Simulation.Server]
  # API

  def start_link(name \\ @name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @spec mess_something_up(pid | atom, boolean) :: no_return | :noop
  def mess_something_up(pid \\ @name, nasty_mode) do
    cond do
      nasty_mode and :rand.uniform < @mess_up_frequency ->
        GenServer.cast(pid, {:mess_something_up})
      true ->
        :noop
    end
  end

  # Callbacks

  def init(:ok) do
    {:ok, nil}
  end

  def handle_cast({:mess_something_up}, _) do
    @process_pool
    |> Nasty.ProcessPicker.random
    |> Nasty.ProcessKiller.kill
    |> Output.Console.draw_text
    {:noreply, nil}
  end
end
