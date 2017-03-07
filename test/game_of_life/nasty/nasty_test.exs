defmodule GameOfLife.NastyTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Nasty

  test "formats killed process' name properly" do
    input = %{
      names: [
        "Random Process",
        "Another Process"
      ]
    }
    output = Enum.map(input.names, &Nasty.format(&1))
    expected_output = [
      " (╯°□°）╯︵ ssǝɔoɹd ɯopuɐɹ",
      " (╯°□°）╯︵ ssǝɔoɹd ɹǝɥʇouɐ"
    ]
    assert output == expected_output
  end
end
