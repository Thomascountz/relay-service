defmodule RelayService.SentimentTest do
  use ExUnit.Case
  import Mock

  @sentiment_analysis_service_url Application.fetch_env!(
                                    :relay_service,
                                    :ibm_watson_tone_analyzer_url
                                  )

  @sentiment_analysis_service_key Application.fetch_env!(
                                    :relay_service,
                                    :ibm_watson_tone_analyzer_key
                                  )

  @joyous_text "I love this time of year!"
  @joyous_response {:ok,
                    %HTTPoison.Response{
                      body:
                        "{\"document_tone\":{\"tones\":[{\"score\":0.930452,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"I love this time of year!\",\"tones\":[{\"score\":0.832088,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]}]}",
                      headers: [
                        {"Content-Type", "application/json"},
                        {"Content-Length", "706"}
                      ],
                      request_url: "http://localhost",
                      status_code: 200
                    }}
  @request_error_response {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}}
  @api_401_response {:ok,
                     %HTTPoison.Response{
                       body: "{\"code\":401, \"error\": \"Unauthorized\"}",
                       headers: [
                         {"Content-Type", "application/json"},
                         {"Content-Length", "37"}
                       ],
                       request_url: "http://localhost",
                       status_code: 401
                     }}

  test "analyze/1 calls HTTPoison to make an NPL analysis request" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      url = @sentiment_analysis_service_url
      encoded_text = "{\"text\":\"#{@joyous_text}\"}"
      headers = [{"Content-Type", "application/json"}]
      options = [hackney: [basic_auth: {"apikey", @sentiment_analysis_service_key}]]

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

  test "analyze/1 returns an :ok tuple when request is successful" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      assert {:ok, _} = RelayService.Sentiment.analyze(@joyous_text)
    end
  end

  test "analyze/1 returns the result body as json when request is successful" do
    expected_response =
      "{\"document_tone\":{\"tones\":[{\"score\":0.930452,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"I love this time of year!\",\"tones\":[{\"score\":0.832088,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"}]}]}"

    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @joyous_response end) do
      {:ok, response} = RelayService.Sentiment.analyze(@joyous_text)
      assert response == expected_response
    end
  end

  test "analyze/1 returns an :error tuple when the request is unsuccessful" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @request_error_response end) do
      assert {:error, _} = RelayService.Sentiment.analyze("Lorem Ipsum")
    end
  end

  test "analyze/1 returns an :error tuple when the api returns a non-200 status code" do
    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @api_401_response end) do
      assert {:error, _} = RelayService.Sentiment.analyze("Lorem Ipsum")
    end
  end

  test "analyze/1 returns an error reason when the request is unsuccessful" do
    expected_error_response = :econnrefused

    with_mock(HTTPoison, post: fn _url, _body, _headers, _options -> @request_error_response end) do
      {:error, reason} = RelayService.Sentiment.analyze("Lorem Ipsum")
      assert reason == expected_error_response
    end
  end
end
