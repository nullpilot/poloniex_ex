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

  end

  def return_openorders() do

  end

  def return_tradehistory() do

  end

  def return_ordertrades() do

  end

  def buy() do

  end

  def sell() do

  end

  def cancelOrder() do

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
        Poison.decode(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found."}
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
end
