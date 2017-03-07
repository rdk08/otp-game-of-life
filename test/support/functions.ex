defmodule GameOfLife.Test.Support.Functions do
  def times(n, term) when n > 0, do: Enum.map(1..n, fn (_) -> term end)
  def times(n, _) when n <= 0, do: []

  def random_atom do
    1..100_000
    |> Stream.map(fn (_) -> :crypto.strong_rand_bytes(1) end)
    |> Stream.filter(&Regex.match?(~r/[a-zA-Z0-9]/, &1))
    |> Enum.take(32)
    |> List.to_string
    |> String.to_atom
  end

  def random_key do
    [:rand.uniform, :rand.uniform]
    |> Enum.map(&(&1*100_000))
    |> Enum.map(&round(&1))
    |> List.to_tuple
  end
end
