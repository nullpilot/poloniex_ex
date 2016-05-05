defmodule Poloniex.Trading do
  use HTTPoison.Base

  def return_balances() do
  end

  def return_complete_balances() do
  end

  def return_openorders() do
  end

  def return_tradehistory() do
  end

  def return_ordertrades() do
  end

  @doc """
    Places a limit buy order in a given market.Required POST parameters are "currencyPair", "rate", and "amount".
    If successful, the method will return the order number.
  """
  def buy(first, second, rate, amount) do
    params = [currencyPair: Poloniex.to_pair(first, second), rate: rate, amount: amount]
    {:ok, response} = Poloniex.Trading.post "", {:form, params}
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

  def generate_sign_header(body) do
    Base.encode16(:crypto.hmac(:sha256, api_key, body))
  end

  def api_key do
    Application.get_env(Poloniex, :key)
  end


  defp process_url(url) do
    "https://poloniex.com/tradingApi" <> url
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, ["Key": api_key])
  end

  defp process_request_headers(headers), do: headers ++ ["Key": api_key]

end
