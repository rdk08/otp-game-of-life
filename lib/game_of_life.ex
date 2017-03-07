defmodule GameOfLife do
  use Application

  def start(_, _) do
    GameOfLife.Supervisor.start_link
  end
end
