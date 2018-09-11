use Mix.Config

port =
  case System.get_env("PORT") do
    port when is_binary(port) -> String.to_integer(port)
    nil -> 80
  end

config :relay_service, port: port

config :relay_service,
  ibm_watson_tone_analyzer_key: System.get_env("IBM_WATSON_TONE_ANALYZER_KEY")

config :relay_service,
  ibm_watson_tone_analyzer_url: System.get_env("IBM_WATSON_TONE_ANALYZER_URL")
