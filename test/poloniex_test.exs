defmodule PoloniexTest do
  use ExUnit.Case, async: true

  doctest Poloniex

  test "correctly returns float from the USDT/BTC ticker" do
    assert is_float(Poloniex.ticker_last("USDT","BTC"))
  end
end
