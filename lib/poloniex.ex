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
    params = [command: "returnLoanOrders", currency: currency]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get

    data = response.body
    |> Poison.Parser.parse!
    |> Map.update!("demands", fn val -> Enum.map(val, &Poloniex.LoanOrder.new/1) end)
    |> Map.update!("offers", fn val -> Enum.map(val, &Poloniex.LoanOrder.new/1) end)
    {:ok, data}
  end


  defp process_url(url) when is_bitstring(url) do
    "https://poloniex.com/public?" <> url
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, [])
  end

  defp process_request_headers(headers), do: headers

end

defmodule Poloniex.LoanOrder do
  # Structs vs maps https://engineering.appcues.com/2016/02/02/too-many-dicts.html
  defstruct [rate: nil, amount: nil, range_min: nil, range_max: nil]
  use ExConstructor
  use Vex.Struct

  validates :rate, presence: true
  validates :amount, presence: true
  validates :range_min, presence: true
  validates :range_max, presence: true

end
