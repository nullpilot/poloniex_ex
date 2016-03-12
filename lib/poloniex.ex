defmodule Poloniex do
  use HTTPoison.Base

  @moduledoc """
  Wrapper around public Poloniex public APIs for market data: including trading pairs of Ethereum, Bitcoin, Litecoin, Dogecoin and others.
  """

  @doc """
  Returns last ticker float for pair of first and second params
  """
  def ticker_last(first, second) do
    return_ticker[first <> "_" <> second]["last"]
    |> String.to_float
  end

  def return_ticker do
    {:ok, response} = get("returnTicker")
    response.body
    |> Poison.Parser.parse!
  end

  defp process_url(url) when is_bitstring(url) do
    "https://poloniex.com/public?command=" <> url
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, [])
  end

  defp process_request_headers(headers), do: headers


end
