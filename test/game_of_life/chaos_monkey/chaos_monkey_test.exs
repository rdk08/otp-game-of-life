defmodule GameOfLife.ChaosMonkeyTest do
  use ExUnit.Case, async: true

  alias GameOfLife.ChaosMonkey

  test "formats killed process' name properly" do
    input = %{
      names: [
        "Random Process",
        "Another Process"
      ]
    }

    output = Enum.map(input.names, &ChaosMonkey.format(&1))

    expected_output = [
      " (╯°□°）╯︵ ssǝɔoɹd ɯopuɐɹ",
      " (╯°□°）╯︵ ssǝɔoɹd ɹǝɥʇouɐ"
    ]

    assert output == expected_output
  end
end
