defmodule GameOfLife.Output.Console.Server do
  use GenServer

  alias GameOfLife.Output.{Board, Console}

  @name __MODULE__

  # API

  def start_link(name \\ @name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @spec draw_board(pid | atom, %Board{}) :: :ok | String.t
  def draw_board(pid \\ @name, %Board{}=board) do
    GenServer.call(pid, {:draw_board, board})
  end

  @spec draw_text(pid | atom, String.t) :: :ok | String.t
  def draw_text(pid \\ @name, text) do
    GenServer.call(pid, {:draw_text, text})
  end

  # Callbacks

  def init(:ok) do
    {:ok, nil}
  end

  def handle_call({:draw_board, board}, _, _) do
    {:reply, Console.draw_board(board), nil}
  end

  def handle_call({:draw_text, text}, _, _) do
    {:reply, Console.draw_text(text), nil}
  end
end
