defmodule PoloniexTest do
  use ExUnit.Case, async: true

  doctest Poloniex

  test "returns float from the USDT/BTC ticker" do
    num = Poloniex.return_ticker
    |> Poloniex.ticker_last("USDT","BTC")
    assert is_float(num)
  end

  test "returns order book" do
    book = Poloniex.return_order_book("BTC", "ETH")
    assert is_list(book["asks"])
  end
end
