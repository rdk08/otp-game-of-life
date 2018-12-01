defmodule GameOfLife.ChaosMonkey.ProcessPickerTest do
  use ExUnit.Case

  alias GameOfLife.{ChaosMonkey, Simulation}
  alias GameOfLife.Output.{Console, Formatter}

  setup do
    {:ok, _} = Formatter.Server.start_link()
    {:ok, _} = Console.Server.start_link()
    {:ok, _} = Simulation.Server.start_link()
    {:ok, pool: [Formatter.Server, Console.Server, Simulation.Server]}
  end

  @tag :integration
  test "picks random process from process pool", %{pool: pool} do
    output = ChaosMonkey.ProcessPicker.random(pool)
    {formatted_name, pid} = output

    expected_names = [
      "Formatter Server",
      "Console Server",
      "Simulation Server"
    ]

    assert Enum.member?(expected_names, formatted_name)
    assert is_pid(pid)
    assert Process.alive?(pid)
  end
end
