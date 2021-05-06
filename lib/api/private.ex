defmodule ExFtx.Api.Private do
  @moduledoc """
  Interface for authenticated HTTP requests
  """

  import ExFtx.Api
  alias ExFtx.Config
  alias ExFtx.Auth

  @type path :: String.t()
  @type params :: map | [map]
  @type config :: map | nil
  @type response :: ExFtx.Api.response()

  @spec get(path, params, config) :: response
  def get(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)
    qs = query_string(path, params)

    qs
    |> url(config)
    |> HTTPoison.get(headers("GET", qs, %{}, config))
    |> parse_response()
  end

  @spec post(path, params, config) :: response
  def post(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.post(Jason.encode!(params), headers("POST", path, params, config))
    |> parse_response()
  end

  @spec delete(path, params, config) :: response
  def delete(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.delete(headers("DELETE", path, params, config))
    |> parse_response()
  end

  defp headers(method, path, body, config) do
    timestamp = Auth.timestamp()
    signed = Auth.sign(timestamp, method, path, body, config.api_secret)

    [
      "Content-Type": "application/json",
      "FTX-KEY": config.api_key,
      "FTX-SIGN": signed,
      "FTX-TS": timestamp
    ]
  end
end
