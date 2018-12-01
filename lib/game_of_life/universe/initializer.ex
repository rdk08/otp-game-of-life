defmodule GameOfLife.Universe.Initializer do
  alias GameOfLife.{Cell, Universe}

  @default_opts dimensions: {40, 40},
                alive_cells: :random

  @doc """
  Builds universe struct and starts all cell servers.
  """
  @spec initialize(keyword, pid | atom) :: %Universe{}
  def initialize(opts, cell_supervisor) do
    opts = Keyword.merge(@default_opts, opts)
    universe = Universe.initialize(opts[:dimensions])

    universe.cells
    |> Enum.map(&prepare_cell(&1, universe, opts[:alive_cells]))
    |> Enum.map(&start_cell_server(cell_supervisor, &1))

    universe
  end

  defp prepare_cell(key, universe, alive_cells) do
    state = determine_state(alive_cells, key)
    neighbours = Universe.get_neighbours(universe, key)
    {key, {state, neighbours}}
  end

  defp determine_state(:random, _) do
    percent_alive = 20.0
    if :rand.uniform() * 100 < percent_alive, do: :alive, else: :dead
  end

  defp determine_state(alive_cells, key) do
    case Enum.member?(alive_cells, key) do
      true -> :alive
      _ -> :dead
    end
  end

  defp start_cell_server(cell_supervisor, {key, {state, neighbours}}) do
    {:ok, _} = Cell.Supervisor.start_child(cell_supervisor, key, {state, neighbours})
  end
end
