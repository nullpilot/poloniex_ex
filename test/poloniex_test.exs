defmodule PoloniexTest do
  use ExUnit.Case, async: true

  doctest Poloniex

  test "correctly returns float from the USDT/BTC ticker" do
    num = Poloniex.return_ticker
    |> Poloniex.ticker_last("USDT","BTC")
    assert is_float(num)
  end
end
