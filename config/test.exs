use Mix.Config

config :relay_service, port: 4001
config :logger, level: :error

config :relay_service,
  ibm_watson_tone_analyzer_key: "ibm_watson_tone_analyzer_key"

config :relay_service,
  ibm_watson_tone_analyzer_url: "ibm_watson_tone_analyzer_url"
