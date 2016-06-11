defmodule PoloniexTest do
  use ExUnit.Case, async: true

  doctest Poloniex

  test "returns float from the USDT/BTC ticker" do
    {:ok, ticker} = Poloniex.return_ticker
    num = Poloniex.ticker_last(ticker,"USDT","BTC")
    assert is_float(num)
  end

  test "returns order book" do
    {:ok, book} = Poloniex.return_order_book("BTC", "ETH")
    assert is_list(book.asks)
  end

  test "returns loan orders" do
    {:ok, loan_book} = Poloniex.return_loan_orders("BTC")
    assert Vex.valid?(hd loan_book["offers"]) && Vex.valid?(hd loan_book["demands"])
  end

end
