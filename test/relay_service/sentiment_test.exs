defmodule RelayService.SentimentTest do
  use ExUnit.Case
  import Mock

  @joyous_text "I love this time of year! The leaves begin to change, and I enjoy many cups of tea!"
  @joyous_response {:ok,
                    %HTTPoison.Response{
                      body:
                        "{\"document_tone\":{\"tones\":[{\"score\":0.930452,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"I love this time of year!\",\"tones\":[{\"score\":0.832088,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},{\"sentence_id\":1,\"text\":\"The leaves begin to change, and I enjoy many cups of tea!\",\"tones\":[{\"score\":0.90188,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]}]}",
                      headers: [
                        {"Date", "Fri, 07 Sep 2018 16:45:10 GMT"},
                        {"Content-Type", "application/json"},
                        {"Content-Length", "706"},
                        {"Connection", "keep-alive"},
                        {"X-Powered-By", "Servlet/3.1"},
                        {"Access-Control-Allow-Origin", "*"},
                        {"X-Service-Api-Version", "3.5.6; 2017-09-21"},
                        {"X-Service-Build-Number", "2018-08-28T05:18:42"},
                        {"Cache-Control", "no-store"},
                        {"Pragma", "no-cache"},
                        {"X-XSS-Protection", "1; mode=block"},
                        {"X-Content-Type-Options", "nosniff"},
                        {"Content-Security-Policy", "default-src 'none'"},
                        {"Content-Language", "en-US"},
                        {"x-global-transaction-id", "60ab398cd2b2b62fd202939019fa109f"},
                        {"X-DP-Watson-Tran-ID", "60ab398cd2b2b62fd202939019fa109f"}
                      ],
                      request_url: "http://localhost",
                      status_code: 200
                    }}
  @error_response {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}

  test "analyze/2 calls HTTPoison to make an NPL analysis request" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      url = RelayService.Sentiment.sentiment_analysis_service_url()
      encoded_text = "{\"text\":\"#{@joyous_text}\"}"
      headers = [{"Content-Type", "application/json"}]
      options = [hackney: [basic_auth: {"apikey", "api-key"}]]

      RelayService.Sentiment.analyze(@joyous_text)

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

  test "analyze/2 returns an :ok tuple when request is successful" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      assert {:ok, _} = RelayService.Sentiment.analyze(@joyous_text)
    end
  end

  test "analyze/2 returns the result body as json when request is successful" do
    expected_response =
      "{\"document_tone\":{\"tones\":[{\"score\":0.930452,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"I love this time of year!\",\"tones\":[{\"score\":0.832088,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},{\"sentence_id\":1,\"text\":\"The leaves begin to change, and I enjoy many cups of tea!\",\"tones\":[{\"score\":0.90188,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]}]}"

    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      {:ok, response} = RelayService.Sentiment.analyze(@joyous_text)
      assert response == expected_response
    end
  end

  test "analyze/2 returns an :error tuple when the request is unsuccessful" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @error_response end) do
      assert {:error, _} = RelayService.Sentiment.analyze("Lorem Ipsum")
    end
  end

  test "analyze/2 returns an error reason when the request is unsuccessful" do
    expected_error_response = :econnrefused

    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @error_response end) do
      {:error, reason} = RelayService.Sentiment.analyze("Lorem Ipsum")
      assert reason == expected_error_response
    end
  end
end