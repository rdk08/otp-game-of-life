defmodule GameOfLife.Simulation.State do
  @name __MODULE__

  @spec start_link(atom, keyword) :: {:ok, pid} | {:error, any}
  def start_link(name \\ @name, simulation_opts) do
    Agent.start_link(fn ->
      %{generations: simulation_opts[:generations]}
    end, name: name)
  end

  @spec remaining_generations(atom) :: integer
  def remaining_generations(name \\ @name) do
    Agent.get(name, &(&1.generations))
  end

  @spec count_generation(atom) :: :ok
  def count_generation(name \\ @name) do
    Agent.update(name, &decrease_generations/1)
  end

  defp decrease_generations(state) do
    Map.update(state, :generations, nil, &(&1 - 1))
  end

  @spec simulation_ended?(atom) :: boolean
  def simulation_ended?(name \\ @name) do
    generations = Agent.get(name, &(&1.generations))
    cond do
      generations > 0 -> false
      true -> true
    end
  end
end
