defmodule RelayService.Endpoint do
  use Plug.Router
  require Logger

  plug(Plug.Logger)
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
    case conn.query_params |> Map.fetch("text") do
      {:ok, text} ->
        case RelayService.Sentiment.analyze(text) do
          {:ok, analysis} ->
            send_resp(conn, 200, analysis)

          {:error, response} ->
            Logger.warn("API returned a non-200: #{response}")
            send_resp(conn, 500, internal_server_error())
        end

      :error ->
        send_resp(conn, 400, bad_request())
    end
  end

  defp say_hello(name) do
    Poison.encode!(%{response: "Hello, #{name}!"})
  end

  defp missing_name do
    Poison.encode!(%{error: "Expected a \"name\" key"})
  end

  defp bad_request do
    Poison.encode!(%{error: "Bad Request"})
  end

  defp internal_server_error do
    Poison.encode!(%{error: "Internal Server Error"})
  end
end
