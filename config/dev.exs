use Mix.Config

config :relay_service, port: 4000
config :mix_test_watch, clear: true

config :relay_service,
  ibm_watson_tone_analyzer_key: System.get_env("IBM_WATSON_TONE_ANALYZER_KEY")
