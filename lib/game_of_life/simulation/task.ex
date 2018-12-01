defmodule GameOfLife.Simulation.Task do
  alias GameOfLife.{ChaosMonkey, Simulation}
  alias GameOfLife.Output.Console

  def start_link(simulation_opts) do
    Task.start_link(fn -> run(:continue, simulation_opts) end)
  end

  @spec run(:continue | :end, keyword) :: String.t()
  def run(:continue, simulation_opts) do
    case Simulation.State.simulation_ended?() do
      false ->
        generation(simulation_opts)
        run(:continue, simulation_opts)

      true ->
        run(:end, simulation_opts)
    end
  end

  def run(:end, _) do
    Console.Server.draw_text("Simulation finished!")
  end

  defp generation(simulation_opts) do
    Simulation.Server.run_generation()
    Simulation.State.count_generation()
    ChaosMonkey.Server.mess_something_up(chaos_monkey: simulation_opts[:chaos_monkey])
    sleep(simulation_opts[:sleep])
  end

  defp sleep(time), do: :timer.sleep(time)
end
