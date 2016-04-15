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

  test "returns loan orders" do
    {:ok, loan_book} = Poloniex.return_loan_orders("BTC")
    assert is_list(loan_book["offers"]) && is_list(loan_book["demands"])
  end
end
