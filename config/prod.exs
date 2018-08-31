use Mix.Config

port =
  case System.get_env("PORT") do
    port when is_binary(port) -> String.to_integer(port)
    nil -> 80
  end

config :hello_webhook, port: port
