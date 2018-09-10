defmodule RelayService.Sentiment do
  require Logger

  @sentiment_analysis_service_url "https://gateway-wdc.watsonplatform.net/tone-analyzer/api/v3/tone?version=2017-09-21"
  def sentiment_analysis_service_url, do: @sentiment_analysis_service_url

  def analyze(text) do
    case sentiment_analysis_service_url()
         |> HTTPoison.post(encode_text(text), headers(), options()) do
      {:ok, response} -> {:ok, response.body}
      {:error, error} -> {:error, error.reason}
    end
  end

  defp headers do
    [
      {"Content-Type", "application/json"}
    ]
  end

  defp encode_text(text) do
    Poison.encode!(%{text: text})
  end

  defp options do
    [
      hackney: [
        basic_auth:
          {"apikey", Application.fetch_env!(:relay_service, :ibm_watson_tone_analyzer_key)}
      ]
    ]
  end
end
