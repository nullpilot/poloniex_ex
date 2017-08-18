defmodule Poloniex.Trading do
  use HTTPoison.Base

  @endoint "https://poloniex.com/tradingApi"

  @doc """
    Queries a full list of balances in your account.
  """
  def return_balances() do
    body = [
      nonce: get_microseconds(),
      command: "returnBalances"
    ]

    api_query(body)
  end

  def return_complete_balances() do
    body = [
      nonce: get_microseconds(),
      command: "returnCompleteBalances"
    ]

    api_query(body)
  end

  def return_deposit_addresses() do
    body = [
      nonce: get_microseconds(),
      command: "returnDepositAddresses"
    ]

    api_query(body)
  end

  def generate_new_address(currency) do
    body = [
      currency: currency,
      nonce: get_microseconds(),
      command: "generateNewAddress"
    ]

    api_query(body)
  end

  def return_deposits_withdrawals(start_date, end_date) do
    body = [
      start: start_date,
      end: end_date,
      nonce: get_microseconds(),
      command: "returnDepositsWithdrawals"
    ]

    api_query(body)
  end

  def return_open_orders(first, second) do
    return_open_orders(first <> "_" <> second)
  end

  def return_open_orders(pair \\ "all") do
    body = [
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "returnOpenOrders"
    ]

    api_query(body)
  end

  def return_trade_history(pair \\ "all") do
    return_trade_history(pair, nil, nil)
  end

  def return_trade_history(first, second) do
    return_trade_history(first <> "_" <> second, nil, nil)
  end

  def return_trade_history(first, second, start_date, end_date) do
    return_trade_history(first <> "_" <> second, start_date, end_date)
  end

  def return_trade_history(pair, start_date, end_date) do
    body_base = [
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "returnTradeHistory"
    ]

    body = cond do
      is_number(start_date) and is_number(end_date) ->
        [{:start, start_date}, {:end, end_date} | body_base]
      is_number(start_date) ->
        [{:start, start_date} | body_base]
      is_number(end_date) ->
        [{:end, end_date} | body_base]
      true ->
        body_base
    end

    api_query(body)
  end

  def return_order_trades(order_number) do
    body = [
      orderNumber: order_number,
      nonce: get_microseconds(),
      command: "returnOrderTrades"
    ]

    api_query(body)
  end

  def buy(first, second, amount, rate) do
    buy(first <> "_" <> second, amount, rate)
  end

  # TODO: extra params
  def buy(pair, amount, rate) do
    body = [
      rate: format_number(rate),
      amount: format_number(amount),
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "buy"
    ]

    api_query(body)
  end


  def sell(first, second, amount, rate) do
    sell(first <> "_" <> second, amount, rate)
  end

  # TODO: extra params
  def sell(pair, amount, rate) do
    body = [
      rate: format_number(rate),
      amount: format_number(amount),
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "sell"
    ]

    api_query(body)
  end

  def cancel_order(order_number) do
    body = [
      orderNumber: order_number,
      nonce: get_microseconds(),
      command: "cancelOrder"
    ]

    api_query(body)
  end

  def moveOrder() do

  end

  def withdraw() do

  end

  def returnFeeInfo() do

  end

  def returnAvailableAccountBalances() do

  end

  def returnTradableBalances() do

  end

  def transferBalance() do

  end

  def returnMarginAccountSummary() do

  end

  def marginBuy() do

  end

  def marginSell() do

  end

  def getMarginPosition() do

  end

  def createLoanOffer() do

  end

  def cancelLoanOffer() do

  end

  def returnOpenLoanOffers() do

  end

  def returnActiveLoans() do

  end

  def toggleAutoRenew() do

  end

  defp api_query(body, options \\ []) do
    body = URI.encode_query(body)

    case post(@endoint, body, get_headers(body), options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # TODO: catch "invalid command" error, which returns with 200
        Poison.decode(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found."}
      {:ok, %HTTPoison.Response{status_code: 422, body: body}} ->
        # TODO: extract error message from response
        {:error, "Missing or malformed input"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp get_headers(body) do
    config = Application.get_env(:poloniex, Poloniex.Trading)

    [
      "key": Keyword.get(config, :key),
      "sign": generate_sign_header(body, Keyword.get(config, :secret)),
      "content-type": "application/x-www-form-urlencoded; charset=utf-8"
    ]
  end

  defp get_microseconds() do
    DateTime.utc_now |> DateTime.to_unix(:microsecond)
  end

  defp generate_sign_header(body, secret) do
    Base.encode16(:crypto.hmac(:sha512, secret, body))
  end

  defp format_number(number) when is_float(number) do
    :erlang.float_to_binary(number, [:compact, { :decimals, 8 }])
  end
  defp format_number(number), do: number
end
