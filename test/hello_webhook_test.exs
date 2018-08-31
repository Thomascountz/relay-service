defmodule HelloWebhookTest do
  use ExUnit.Case, async: true
  use Plug.Test

  doctest HelloWebhook

  @opts HelloWebhook.Endpoint.init([])

  test "GET /hello" do
    conn = conn(:get, "/hello")
    conn = HelloWebhook.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello, World!"
  end

  test "POST /hello with a name" do
    body = Poison.encode!(%{name: "Thomas"})

    conn =
      conn(:post, "hello", body)
      |> put_req_header("content-type", "application/json")

    conn = HelloWebhook.Endpoint.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == Poison.encode!(%{response: "Hello, Thomas!"})
  end

  test "POST /hello without a name" do
    conn = conn(:post, "hello")
    conn = HelloWebhook.Endpoint.call(conn, @opts)
    assert conn.state == :sent
    assert conn.status == 422
    assert conn.resp_body == Poison.encode!(%{error: "Expected a \"name\" key"})
  end
end
