defmodule RelayService.Sentiment do
  require Logger

  @sentiment_analysis_service_url Application.fetch_env!(
                                    :relay_service,
                                    :ibm_watson_tone_analyzer_url
                                  )

  @sentiment_analysis_service_key Application.fetch_env!(
                                    :relay_service,
                                    :ibm_watson_tone_analyzer_key
                                  )

  def analyze(text) do
    case HTTPoison.post(
           @sentiment_analysis_service_url,
           encode_text(text),
           headers(),
           options()
         ) do
      {:ok, response} ->
        case response.status_code do
          200 -> {:ok, response.body}
          _ -> {:error, response.body}
        end

      {:error, error} ->
        {:error, error.reason}
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
        basic_auth: {"apikey", @sentiment_analysis_service_key}
      ]
    ]
  end
end
