defmodule GameOfLife.ChaosMonkey.Server do
  use GenServer

  alias GameOfLife.{ChaosMonkey, Output}

  @env Mix.env()
  @mess_up_frequency 25
  @name __MODULE__
  @process_pool [
    GameOfLife.Output.Console.Server,
    GameOfLife.Output.Formatter.Server,
    GameOfLife.Cell.Server,
    GameOfLife.Universe.Server,
    GameOfLife.Simulation.Server
  ]

  # API

  def start_link(name \\ @name, process_pool \\ @process_pool) do
    GenServer.start_link(__MODULE__, %{process_pool: process_pool}, name: name)
  end

  @spec mess_something_up(pid | atom, keyword) :: no_return | :noop
  def mess_something_up(pid \\ @name, opts)

  def mess_something_up(pid, chaos_monkey: true) do
    if mess_up?() do
      GenServer.cast(pid, {:mess_something_up})
    else
      :noop
    end
  end

  def mess_something_up(_, _), do: :noop

  defp mess_up?() do
    random_number = Enum.random(1..100)
    random_number <= @mess_up_frequency
  end

  # Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:mess_something_up}, %{process_pool: process_pool} = state) do
    process_pool
    |> ChaosMonkey.ProcessPicker.random()
    |> ChaosMonkey.ProcessKiller.kill()
    |> Output.Console.draw_text(@env)

    {:noreply, state}
  end
end
