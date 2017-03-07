## Game Of Life

#### Project goals

  - rely heavily on OTP concepts/constructs
  - make it fault-tolerant
  - have fun

#### Configuration

Edit `config/config.exs`:

```elixir
use Mix.Config

config :game_of_life,
  dimensions: {30, 30},   # universe (board) dimensions
  alive_cells: :random,   # initial universe state: predefined or random
  generations: 500,       # number of generations to run
  sleep: 150,             # sleep time (in miliseconds) between each generation
  nasty_mode: false       # randomly kills app processes if set to true
```

#### How to run?

`iex -S mix`
