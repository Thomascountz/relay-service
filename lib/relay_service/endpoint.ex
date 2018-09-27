defmodule RelayService.Endpoint do
  use Plug.Router
  require Logger

  plug(Plug.Logger)

  if :prod == Application.fetch_env!(:relay_service, :env) do
    plug(Plug.SSL)
  end

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  def init(options) do
    options
  end

  def start_link do
    port = Application.fetch_env!(:relay_service, :port)
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [], port: port)
  end

  get "/hello" do
    send_resp(conn, 200, "Hello, World!")
  end

  post "/hello" do
    {status, body} =
      case conn.body_params do
        %{"name" => name} -> {200, say_hello(name)}
        _ -> {422, missing_name()}
      end

    send_resp(conn, status, body)
  end

  get "/sentiment/analyze" do
    {status, body} =
      case conn.query_params |> Map.fetch("text") do
        {:ok, text} -> analyze_sentiment(text)
        _ -> {400, bad_request()}
      end

    send_resp(conn, status, body)
  end

  post "/sentiment/analyze" do
    {status, body} =
      case conn.body_params do
        %{"text" => text} -> analyze_sentiment(text)
        _ -> {400, bad_request()}
      end

    send_resp(conn, status, body)
  end

  defp say_hello(name) do
    Poison.encode!(%{response: "Hello, #{name}!"})
  end

  defp missing_name do
    Poison.encode!(%{error: "Expected a \"name\" key"})
  end

  defp analyze_sentiment(text) do
    case RelayService.Sentiment.analyze(text) do
      {:ok, analysis} ->
        {200, analysis}

      {:error, reason} ->
        Logger.warn("API returned a non-200: #{reason}")
        {500, internal_server_error()}
    end
  end

  defp bad_request do
    Poison.encode!(%{error: "Bad Request"})
  end

  defp internal_server_error do
    Poison.encode!(%{error: "Internal Server Error"})
  end
end
