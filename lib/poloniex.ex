defmodule Poloniex do
  use HTTPoison.Base

  @moduledoc """
  Wrapper around public Poloniex public APIs for market data: including trading pairs of Ethereum, Bitcoin, Litecoin, Dogecoin and others.
  """

  @doc """
  Returns last ticker float for pair of first and second params
  """
  def ticker_last(tickers, first, second) when is_map(tickers) do
    tickers[first <> "_" <> second]["last"]
    |> String.to_float
  end

  def return_ticker do
    {:ok, response} = [command: "returnTicker"] |> URI.encode_query |> get
    response.body
    |> Poison.Parser.parse!
  end

  def return_order_book(first, second, options \\ []) do
    params = options ++ [command: "returnOrderBook", currencyPair: "#{first}_#{second}"]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get
    response.body
    |> Poison.Parser.parse!
  end

  def return_loan_orders(currency) do
    params = options ++ [command: "returnLoanOrders", currency: currency]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get
    {:ok, Poison.Parser.parse!(response.body)}
  end


  defp process_url(url) when is_bitstring(url) do
    "https://poloniex.com/public?" <> url
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, [])
  end

  defp process_request_headers(headers), do: headers


end
