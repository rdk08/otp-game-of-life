defmodule GameOfLife.Mixfile do
  use Mix.Project

  def project do
    [app: :game_of_life,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger], mod: {GameOfLife, []}]
  end

  defp deps do
    [{:gproc, "~> 0.5.0"}]
  end
end
