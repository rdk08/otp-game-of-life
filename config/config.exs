use Mix.Config

config :game_of_life,
  dimensions: {30, 30},   # universe (board) dimensions
  alive_cells: :random,   # initial universe state: predefined or random
  generations: 500,       # number of generations to run
  sleep: 150,             # sleep time (in miliseconds) between each generation
  nasty_mode: false       # randomly kills processes if set to true
