defmodule ExFtx.Api.Public do
  @moduledoc """
  Interface for public HTTP requests
  """

  import ExFtx.Api
  alias ExFtx.Config

  @headers ["Content-Type": "application/json"]

  def get(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)
    qs = query_string(path, params)

    qs
    |> url(config)
    |> HTTPoison.get(@headers)
    |> parse_response()
  end
end
