defmodule GameOfLife.ChaosMonkey do
  @spec format(String.t()) :: String.t()
  def format(name) do
    " (╯°□°）╯︵ " <> flip(name)
  end

  defp flip(name) do
    name
    |> String.downcase()
    |> String.graphemes()
    |> Enum.map(&Enum.find_index(regular_graphemes(), fn g -> g == &1 end))
    |> Enum.map(&Enum.at(flipped_graphemes(), &1))
    |> Enum.reverse()
    |> List.to_string()
  end

  defp regular_graphemes do
    String.graphemes(" {}#<>-_.,abcdefghijklmnopqrstuvwxyz1234567890")
  end

  defp flipped_graphemes do
    String.graphemes(" {}#<>-_  ɐqɔpǝɟɓɥıɾʞlɯuodbɹsʇnʌʍxʎz⇂zƐㄣϛ9ㄥ860")
  end
end
