defmodule GameOfLife.Test.Support.FunctionsTest do
  use ExUnit.Case
  alias GameOfLife.Test.Support.Functions

  test "generates random atom" do
    output = Functions.random_atom
    length = output
             |> Atom.to_string
             |> String.length
    assert is_atom(output)
    assert 32 == length
  end
end
