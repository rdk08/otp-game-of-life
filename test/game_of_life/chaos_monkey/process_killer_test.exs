defmodule GameOfLife.ChaosMonkey.ProcessKillerTest do
  use ExUnit.Case, async: true

  alias GameOfLife.ChaosMonkey

  setup do
    pid = spawn(fn -> :timer.sleep(1000) end)
    Process.register(pid, :test_process)
    {:ok, process: {"Random Process", pid}}
  end

  test "kills process and confirms it with nice message", %{process: process} do
    {_, pid} = process
    output = ChaosMonkey.ProcessKiller.kill(process)
    expected_output = " (╯°□°）╯︵ ssǝɔoɹd ɯopuɐɹ"
    assert output == expected_output
    refute Process.alive?(pid)
  end
end
