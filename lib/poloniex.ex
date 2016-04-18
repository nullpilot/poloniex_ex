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
    data = response.body
    |> Poison.Parser.parse!
    {:ok, data}
  end

  def return_order_book(first, second, options \\ []) do
    params = options ++ [command: "returnOrderBook", currencyPair: "#{first}_#{second}"]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get
    data = response.body
      |> Poison.Parser.parse!
    {:ok, data}
  end

  def return_trade_history(first, second, start_time, end_time) do
    params = [command: "returnTradeHistory", currencyPair: "#{first}_#{second}", from: start_time, to: end_time]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get
    data = response.body
      |> Poison.Parser.parse!
    {:ok, data}
  end

  def return_24h_volume do
     params = [command: "return24hVolume"]
     {:ok, response} = params |> URI.encode_query |> Poloniex.get
     data = response.body
       |> Poison.Parser.parse!
     {:ok, data}
  end

  def return_loan_orders(currency) do
    # official documentation is missing the mention of limit param but it used on the poloniex loan page
    params = [command: "returnLoanOrders", currency: currency, limit: 999999]
    {:ok, response} = params |> URI.encode_query |> Poloniex.get

    data = response.body
    |> Poison.Parser.parse!
    |> Map.update!("demands", fn loan_orders -> Enum.map(loan_orders, &convert_and_construct/1) end)
    |> Map.update!("offers", fn loan_orders-> Enum.map(loan_orders, &convert_and_construct/1) end)
    {:ok, data}
  end

  def return_currencies do
      params = [command: "returnCurrencies"]
      {:ok, response} = params |> URI.encode_query |> Poloniex.get
      data = response.body
      |> Poison.Parser.parse!
      {:ok, data}
  end

  def convert_and_construct(raw_loan_order) do
    loan_order = for {k,v} <- raw_loan_order, into: %{} do
      cond do
        is_integer(v) or is_float(v) -> {k,v}
        true -> {k, String.to_float(v)}
      end
     end
    Poloniex.LoanOrder.new(loan_order)
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

  validates :rate, &is_float/1
  validates :amount, &is_float/1
  validates :range_min, presence: true
  validates :range_max, presence: true

end

defmodule Poloniex.Trade do
   defstruct [date: nil, type: nil, rate: nil, amount: nil]
   use ExConstructor
end
