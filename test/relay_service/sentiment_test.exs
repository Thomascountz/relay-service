defmodule RelayService.SentimentTest do
  use ExUnit.Case
  import Mock

  test "analyze calls sentiment analysis service" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> :ok end) do
      text = "foobar"

      url = RelayService.Sentiment.sentiment_analysis_service_url()
      encoded_text = "{\"text\":\"#{text}\"}"
      headers = [{"Content-Type", "application/json"}]
      options = [hackney: [basic_auth: {"apikey", "api-key"}]]

      RelayService.Sentiment.analyze(text)

      assert_called(
        HTTPoison.post(
          url,
          encoded_text,
          headers,
          options
        )
      )
    end
  end
end
