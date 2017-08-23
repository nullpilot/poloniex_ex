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
    body = [
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "returnTradeHistory"
    ] |> prepend_if(is_number(start_date), :start, start_date)
      |> prepend_if(is_number(end_date), :end, end_date)

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

  # TODO: extra params
  def move_order(order_number, rate) do
    body = [
      rate: format_number(rate),
      orderNumber: order_number,
      nonce: get_microseconds(),
      command: "moveOrder"
    ]

    api_query(body)
  end

  # skip for now
  def withdraw() do

  end

  def return_fee_info() do
    body = [
      nonce: get_microseconds(),
      command: "returnFeeInfo"
    ]

    api_query(body)
  end

  def return_available_account_balances(account \\ nil) do
    body_base = [
      nonce: get_microseconds(),
      command: "returnAvailableAccountBalances"
    ]

    if is_binary(account) do
      api_query([{:account, account} | body_base])
    else
      api_query(body_base)
    end
  end

  def return_tradable_balances() do
    body = [
      nonce: get_microseconds(),
      command: "returnTradableBalances"
    ]

    api_query(body)
  end

  def transfer_balance(currency, amount, from, to) do
    body = [
      currency: currency,
      amount: format_number(amount),
      fromAccount: from,
      toAccount: to,
      nonce: get_microseconds(),
      command: "transferBalance"
    ]

    api_query(body)
  end

  def return_margin_account_summary() do
    body = [
      nonce: get_microseconds(),
      command: "returnMarginAccountSummary"
    ]

    api_query(body)
  end

  def marginBuy() do

  end

  def marginSell() do

  end

  def get_margin_position(first, second) do
    get_margin_position(first <> "_" <> second)
  end

  def get_margin_position(pair \\ "all") do
    body = [
      currencyPair: pair,
      nonce: get_microseconds(),
      command: "getMarginPosition"
    ]

    api_query(body)
  end

  def createLoanOffer() do

  end

  def cancelLoanOffer() do

  end

  def return_open_loan_offers() do
    body = [
      nonce: get_microseconds(),
      command: "returnOpenLoanOffers"
    ]

    api_query(body)
  end

  def return_active_loans() do
    body = [
      nonce: get_microseconds(),
      command: "returnActiveLoans"
    ]

    api_query(body)
  end

  def return_lending_history(start_date \\ nil, end_date \\ nil, limit \\ nil) do
    body = [
      nonce: get_microseconds(),
      command: "returnLendingHistory"
    ] |> prepend_if(start_date != nil, :start, start_date)
      |> prepend_if(end_date != nil, :end, end_date)
      |> prepend_if(limit != nil, :limit, limit)

    api_query(body)
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
      {:ok, %HTTPoison.Response{status_code: 422, body: _body}} ->
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

  defp prepend_if(body, true, key, value) do
    [{key, value} | body]
  end

  defp prepend_if(body, _, _, _), do: body
end
