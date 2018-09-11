defmodule RelayServiceTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  doctest RelayService

  @opts RelayService.Endpoint.init([])

  test "GET /hello" do
    conn = conn(:get, "/hello")
    conn = RelayService.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, World!"
  end

  test "POST /hello with a name" do
    body = Poison.encode!(%{name: "Thomas"})

    conn =
      conn(:post, "hello", body)
      |> put_req_header("content-type", "application/json")

    conn = RelayService.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == Poison.encode!(%{response: "Hello, Thomas!"})
  end

  test "POST /hello without a name" do
    conn = conn(:post, "hello")
    conn = RelayService.Endpoint.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == Poison.encode!(%{error: "Expected a \"name\" key"})
  end

  test "GET /sentiment/analyze" do
    endpoint =
      "sentiment/analyze?text=Lorem%20ipsum%20dolor%20sit%20amet%2C%20consectetur%20adipiscing%20elit.%20Phasellus%20mattis%20ipsum%20luctus%2C%20laoreet%20orci%20at%2C%20placerat%20ipsum.%20Praesent%20vitae%20tristique%20magna."

    with_mock(RelayService.Sentiment,
      analyze: fn _ ->
        {:ok,
         "{\"document_tone\":{\"tones\":[]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit.\",\"tones\":[]},{\"sentence_id\":1,\"text\":\"Ut fermentum ultrices scelerisque.\",\"tones\":[]},{\"sentence_id\":2,\"text\":\"Mauris fringilla massa sed ante semper placerat.\",\"tones\":[]}]}"}
      end
    ) do
      conn = conn(:get, endpoint)
      conn = RelayService.Endpoint.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      assert conn.resp_body ==
               "{\"document_tone\":{\"tones\":[]},\"sentences_tone\":[{\"sentence_id\":0,\"text\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit.\",\"tones\":[]},{\"sentence_id\":1,\"text\":\"Ut fermentum ultrices scelerisque.\",\"tones\":[]},{\"sentence_id\":2,\"text\":\"Mauris fringilla massa sed ante semper placerat.\",\"tones\":[]}]}"
    end
  end

  test "GET /sentiment/analyze without text query params" do
    endpoint = "sentiment/analyze?foo=foo"

    conn = conn(:get, endpoint)
    conn = RelayService.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "GET /sentiment/analyze http error" do
    endpoint = "sentiment/analyze?text=Lorem%20Ipsum"

    with_mock(RelayService.Sentiment,
      analyze: fn _ ->
        {:error, :econnrefused}
      end
    ) do
      conn = conn(:get, endpoint)
      conn = RelayService.Endpoint.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 500
    end
  end
end
