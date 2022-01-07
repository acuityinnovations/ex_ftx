defmodule ExFtx.Private do
  import ExFtx.Api.Private

  @prefix "/api"

  @doc """
  Get account information

  https://docs.ftx.com/#account

  ## Examples

  iex(3)> ExFtx.Private.get_account()

  {:ok,
   %{
     "result" => %{
       "backstopProvider" => false,
       "chargeInterestOnNegativeUsd" => false,
       "collateral" => 0.0,
       "freeCollateral" => 0.0,
       "initialMarginRequirement" => 0.1,
       "leverage" => 10.0,
       "liquidating" => false,
       "maintenanceMarginRequirement" => 0.03,
       "makerFee" => 0.0002,
       "marginFraction" => nil,
       "openMarginFraction" => nil,
       "positionLimit" => nil,
       "positionLimitUsed" => nil,
       "positions" => [],
       "spotLendingEnabled" => false,
       "spotMarginEnabled" => false,
       "takerFee" => 0.0007,
       "totalAccountValue" => 0.0,
       "totalPositionSize" => 0.0,
       "useFttCollateral" => true,
       "username" => "user@example.com"
     },
     "success" => true
   }}
  """
  def get_account(config \\ nil) do
    get("#{@prefix}/account", %{}, config)
  end

  @doc """
  Place a new order.

  https://docs.ftx.com/#place-order

  ## Examples

  iex> ExFtx.Private.create_order(%{
    market: "XRP-PERP",
    side: "sell",
    price: 0.306525,
    type: "limit",
    size: 31431.0,
    postOnly: false,
    clientId: "abcdef"
  }, config)

    {
      "success": true,
      "result": {
        "createdAt": "2019-03-05T09:56:55.728933+00:00",
        "filledSize": 0,
        "future": "XRP-PERP",
        "id": 9596912,
        "market": "XRP-PERP",
        "price": 0.306525,
        "remainingSize": 31431,
        "side": "sell",
        "size": 31431,
        "status": "open",
        "type": "limit",
        "reduceOnly": false,
        "ioc": false,
        "postOnly": false,
        "clientId": null,
      }
    }
  """
  def create_order(params, config \\ nil) do
    post("#{@prefix}/orders", params, config)
  end

  @doc """
  Update order by client order id or external id

  - Using order id

  ExFtx.Private.update_order(%{
    orderId: 9596932
    price: 0.326525,
    size: 31431,
    clientId: "new-client-order-id"
  })

  - Using clientOrderId:

  ExFtx.Private.update_order(%{
    clientOrderId: "abcdef"
    price: 0.326525,
    size: 31431,
    clientId: "new-client-order-id-2"
  })

  {
    "success": true,
    "result": {
      "createdAt": "2019-03-05T11:56:55.728933+00:00",
      "filledSize": 0,
      "future": "XRP-PERP",
      "id": 9596932,
      "market": "XRP-PERP",
      "price": 0.326525,
      "remainingSize": 31431,
      "side": "sell",
      "size": 31431,
      "status": "open",
      "type": "limit",
      "reduceOnly": false,
      "ioc": false,
      "postOnly": false,
      "clientId": "ew-client-order-id-2",
    }
  }
  """
  def update_order(params, config \\ nil) do
    case Map.take(params, [:clientOrderId, :orderId]) do
      %{clientOrderId: client_oid} ->
        post("#{@prefix}/orders/by_client_id/#{client_oid}/modify", params, config)

      %{orderId: order_id} ->
        post("#{@prefix}/orders/#{order_id}/modify", params, config)

      _ ->
        {:error, "invalid params"}
    end
  end

  @doc """
  Cancel order by client order id or external id

  ExFtx.Private.cancel_order(%{
    orderId: 9596932
    price: 0.326525,
    size: 31431,
    clientId: "abcdef"
  })

  {
    "success": true,
    "result": "Order queued for cancelation"
  }
  """
  def cancel_order(params, config \\ nil) do
    case Map.take(params, [:clientOrderId, :orderId]) do
      %{clientOrderId: client_oid} ->
        delete("#{@prefix}/orders/by_client_id/#{client_oid}", %{}, config)

      %{orderId: order_id} ->
        delete("#{@prefix}/orders/#{order_id}", %{}, config)

      _ ->
        {:error, "invalid params"}
    end
  end

  @doc """
  Cancel all orders

  ExFtx.Private.cancel_all_orders(%{})

  {
    "success": true,
    "result": "Orders queued for cancelation"
  }
  """
  def cancel_all_orders(params, config \\ nil) do
    delete("#{@prefix}/orders", params, config)
  end

  @doc """
  Get open orders

  ExFtx.Private.get_open_orders(%{})

  {
    "success": true,
    "result": [
      {
        "createdAt": "2019-03-05T09:56:55.728933+00:00",
        "filledSize": 10,
        "future": "XRP-PERP",
        "id": 9596912,
        "market": "XRP-PERP",
        "price": 0.306525,
        "avgFillPrice": 0.306526,
        "remainingSize": 31421,
        "side": "sell",
        "size": 31431,
        "status": "open",
        "type": "limit",
        "reduceOnly": false,
        "ioc": false,
        "postOnly": false,
        "clientId": null
      }
    ]
  }
  """
  def get_open_orders(instrument_id, config \\ nil) do
    get("#{@prefix}/orders?market=#{instrument_id}", %{}, config)
  end

  @doc """
  Get positions
  iex> ExFtx.Private.get_positions(true, %{})
  {:ok,
  %{
   "result" => [
     %{
       "collateralUsed" => 3.8353,
       "cost" => -38.353,
       "entryPrice" => 3835.3,
       "estimatedLiquidationPrice" => 8927.227624003088,
       "future" => "ETH-PERP",
       "initialMarginRequirement" => 0.1,
       "longOrderSize" => 0.0,
       "maintenanceMarginRequirement" => 0.03,
       "netSize" => -0.01,
       "openSize" => 0.01,
       "realizedPnl" => 7.0022609,
       "shortOrderSize" => 0.0,
       "side" => "sell",
       "size" => 0.01,
       "unrealizedPnl" => 0.0
     }
   ],
   "success" => true
  }}
  """
  def get_positions(showAvgPrice , config \\ nil) do
    get("#{@prefix}/positions", %{showAvgPrice: showAvgPrice}, config)
  end

  @doc """
  Get account balances
  iex> ExFtx.Private.get_wallet_balances(%{})

  {:ok,
  %{
   "result" => [
     %{
       "availableWithoutBorrow" => 3444.42163874,
       "coin" => "USD",
       "free" => 3444.42163874,
       "spotBorrow" => 0.0,
       "total" => 8184.61938589,
       "usdValue" => 8184.619385891926
     },
     %{
       "availableWithoutBorrow" => 0.0,
       "coin" => "BTC",
       "free" => 0.06518392,
       "spotBorrow" => 0.04204707,
       "total" => -0.04204707,
       "usdValue" => -1969.3521939049492
     },
     %{
       "availableWithoutBorrow" => 0.0,
       "coin" => "SOL",
       "free" => 16.49960717,
       "spotBorrow" => 5.6194e-4,
       "total" => -5.6194e-4,
       "usdValue" => -0.0959789677588701
     }
   ],
   "success" => true
  }}
  """
  def get_wallet_balances(config \\ nil) do
    get("#{@prefix}/wallet/balances", %{}, config)
  end


  @doc """
  Get coins info on wallet
  iex> ExFtx.Private.get_wallet_coins(%{})

  {:ok,
  %{
   "result" => [
     %{
       "bep2Asset" => nil,
       "canConvert" => true,
       "canDeposit" => false,
       "canWithdraw" => false,
       "collateral" => true,
       "collateralWeight" => 1.0,
       "creditTo" => nil,
       "erc20Contract" => nil,
       "fiat" => true,
       "hasTag" => false,
       "hidden" => false,
       "id" => "USD",
       "indexPrice" => 1.0,
       "isEtf" => false,
       "isToken" => false,
       "methods" => [],
       "name" => "USD",
       "nftQuoteCurrencyEligible" => true,
       "splMint" => nil,
       "spotMargin" => true,
       "trc20Contract" => nil,
       "usdFungible" => true
     },
    %{
       "bep2Asset" => nil,
       "canConvert" => true,
       "canDeposit" => true,
       "canWithdraw" => true,
       "collateral" => true,
       "collateralWeight" => 0.975,
       "creditTo" => nil,
       "erc20Contract" => nil,
       "fiat" => false,
       "hasTag" => false,
       "hidden" => false,
       "id" => "BTC",
       "indexPrice" => 43037.82211361,
       "isEtf" => false,
       "isToken" => false,
       "methods" => ["btc", "sol"],
       "name" => "Bitcoin",
       "nftQuoteCurrencyEligible" => false,
       "splMint" => "9n4nbM75f5Ui33ZbPYXn59EwSgE8CGsHtAeTH5YFeJ9E",
       "spotMargin" => true,
       "trc20Contract" => nil,
       "usdFungible" => false
     }],
     "success" => true
   }}
  """
  def get_wallet_coins(config \\ nil) do
    get("#{@prefix}/wallet/coins", %{}, config)
  end
end
