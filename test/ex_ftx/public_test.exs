defmodule ExFtx.Inverse.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  test "get market information" do
    use_cassette "public/get_market" do
      {:ok,
       %{
         "success" => true,
         "result" => %{
           "name" => "BTC/USD",
           "baseCurrency" => "BTC",
           "quoteCurrency" => "USD",
           "price" => _,
           "priceIncrement" => 1.0
         }
       }} = ExFtx.Public.get_market("BTC/USD")
    end
  end

  test "get futures contract information" do
    use_cassette "public/get_futures" do
      {:ok,
       %{
         "success" => true,
         "result" => %{
           "name" => "BTC-PERP",
           "ask" => _best_ask,
           "bid" => _best_bid,
           "index" => _index_price,
           "mark" => _mark_price,
           "last" => _last,
           "lowerBound" => _lowest_bound,
           "upperBound" => _upper_bound,
           "priceIncrement" => 1.0,
           "sizeIncrement" => 0.0001
         }
       }} = ExFtx.Public.get_futures("BTC-PERP")
    end
  end
end
