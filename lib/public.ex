defmodule ExFtx.Public do
  import ExFtx.Api.Public

  @prefix "/api"

  @doc """
  Get a single market information (including best bid/ask, tick_size, lot_size, etc)

  https://docs.ftx.com/#get-single-market

  ## Examples

        iex(3)> ExFtx.Public.get_market("BTC/USD")
        
          {:ok,
           %{
             "result" => %{
               "ask" => 57605.0,
               "baseCurrency" => "BTC",
               "bid" => 57595.0,
               "change1h" => 0.00455163754316208,
               "change24h" => 0.06893928147268409,
               "changeBod" => 0.07649037563072322,
               "enabled" => true,
               "highLeverageFeeExempt" => true,
               "last" => 57603.0,
               "minProvideSize" => 0.0001,
               "name" => "BTC/USD",
               "postOnly" => false,
               "price" => 57603.0,
               "priceIncrement" => 1.0,
               "quoteCurrency" => "USD",
               "quoteVolume24h" => 553906344.0361,
               "restricted" => false,
               "sizeIncrement" => 0.0001,
               "type" => "spot",
               "underlying" => nil,
               "volumeUsd24h" => 553906344.0361
             },
             "success" => true
           }}
  """
  def get_market(instrument) do
    get("#{@prefix}/markets/#{instrument}", %{}, nil)
  end

  @doc """
  Get a futures contract information (including index price, mark price, price limits, best bid/ask, etc)

  https://docs.ftx.com/#get-future

  ## Examples

        iex(3)> ExFtx.Public.get_futures("BTC-PERP")
        {:ok,
         %{
           "result" => %{
             "ask" => 54064.0,
             "bid" => 54063.0,
             "change1h" => -9.42245870746037e-4,
             "change24h" => -0.06326329100767406,
             "changeBod" => -0.051465558069778455,
             "description" => "Bitcoin Perpetual Futures",
             "enabled" => true,
             "expired" => false,
             "expiry" => nil,
             "expiryDescription" => "Perpetual",
             "group" => "perpetual",
             "imfFactor" => 0.002,
             "index" => 54104.23051867091,
             "last" => 54076.0,
             "lowerBound" => 5.14e4,
             "marginPrice" => 54075.0,
             "mark" => 54075.0,
             "moveStart" => nil,
             "name" => "BTC-PERP",
             "perpetual" => true,
             "positionLimitWeight" => 1.0,
             "postOnly" => false,
             "priceIncrement" => 1.0,
             "sizeIncrement" => 0.0001,
             "type" => "perpetual",
             "underlying" => "BTC",
             "underlyingDescription" => "Bitcoin",
             "upperBound" => 56833.0,
             "volume" => 76066.4575,
             "volumeUsd24h" => 4235986643.6379
           },
           "success" => true
         }}
  """
  def get_futures(instrument) do
    get("#{@prefix}/futures/#{instrument}", %{}, nil)
  end
end
