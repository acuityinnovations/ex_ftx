import Config

# Read from environment variables
config :ex_ftx,
  api_key: System.get_env("EX_FTX_API_KEY"),
  api_secret: System.get_env("EX_FTX_API_SECRET")
