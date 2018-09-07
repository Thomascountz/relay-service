defmodule RelayService.Sentiment do
  require Logger

  @sentiment_analysis_service_url "https://gateway-wdc.watsonplatform.net/tone-analyzer/api/v3/tone?version=2017-09-21"
  def sentiment_analysis_service_url, do: @sentiment_analysis_service_url

  def analyze(text, apikey) do
    encoded_text = Poison.encode!(%{text: text})
    headers = [{"Content-Type", "application/json"}]
    options = [hackney: [basic_auth: {"apikey", apikey}]]

    HTTPoison.post(sentiment_analysis_service_url(), encoded_text, headers, options)
  end
end
