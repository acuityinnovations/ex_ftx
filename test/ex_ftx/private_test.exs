defmodule ExFtx.Inverse.PrivateTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  setup do
    ExVCR.Config.filter_request_headers("FTX-KEY")
    ExVCR.Config.filter_request_headers("FTX-SIGN")

    ExVCR.Config.filter_sensitive_data(
      "([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})",
      "user@example.com"
    )

    :ok
  end

  test "get account information" do
    use_cassette "private/get_account" do
      {:ok,
       %{
         "success" => true,
         "result" => %{
           "username" => _,
           "totalAccountValue" => _,
           "positions" => _
         }
       }} = ExFtx.Private.get_account()
    end
  end

  test "fail to create an order" do
    use_cassette "private/create_order_failed" do
      {:error, _, _} =
        ExFtx.Private.create_order(%{
          market: "BTC/USDT",
          side: "buy",
          price: 50000,
          type: "limit",
          size: 0.001,
          postOnly: true,
          clientId: "abcdef"
        })
    end
  end

  test "create an order" do
    use_cassette "private/create_order" do
      {:ok,
       %{
         "success" => true,
         "result" => %{
           "id" => _,
           "clientId" => "abcdef",
           "market" => "BTC/USDT",
           "status" => "new",
           "remainingSize" => 0.001
         }
       }} =
        ExFtx.Private.create_order(%{
          market: "BTC/USDT",
          side: "buy",
          price: 50000,
          type: "limit",
          size: 0.001,
          postOnly: true,
          clientId: "abcdef"
        })
    end
  end

  test "cancel an order" do
    use_cassette "private/cancel_order" do
      {:ok,
       %{
         "success" => true,
         "result" => _
       }} =
        ExFtx.Private.cancel_order(%{
          clientOrderId: "abcdef"
        })
    end
  end

  test "cancel all orders" do
    use_cassette "private/cancel_all_orders" do
      {:ok,
       %{
         "success" => true,
         "result" => _
       }} = ExFtx.Private.cancel_all_orders(%{})
    end
  end

  test "get open orders" do
    use_cassette "private/get_open_orders" do
      {:ok,
       %{
         "success" => true,
         "result" => [
           %{
             "id" => _,
             "clientId" => "aaaaaa",
             "market" => "BTC/USDT",
             "status" => "open",
             "remainingSize" => 0.001
           }
         ]
       }} = ExFtx.Private.get_open_orders("BTC/USDT")
    end
  end
end
