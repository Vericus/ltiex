defprotocol Ltiex.Signable do
  @moduledoc """
  Protocol used as a base for generating LTI signatures.

  Implement this protocol for structs/
  """
  alias Ltiex.Request

  @type t :: Signable.t()

  @spec request(t) :: {:ok, Request.t()} | {:error, term}
  def request(signable)
end

defimpl Ltiex.Signable, for: Map do
  def request(%{params: ps, url: url, method: m})
      when is_map(ps) and is_binary(url) and m in ["POST", "GET"] do
    {:ok, %Ltiex.Request{params: ps, url: url, method: m}}
  end

  def request(_), do: {:error, :invalid_request}
end

defimpl Ltiex.Signable, for: Plug.Conn do
  alias Plug.Conn
  alias Ltiex.Request
  alias Ltiex.Internal

  import Plug.Conn

  def request(conn) do
    conn
    |> get_req_header("content-type")
    |> Enum.at(0)
    |> Plug.Conn.Utils.content_type()
    |> case do
      {:ok, "application", t, _} when t in ["xml", "json"] ->
        parse_request(conn, :header)

      _ ->
        parse_request(conn, :body)
    end
  end

  def parse_request(%Conn{params: params} = conn, :body) when is_map(params) do
    url =
      conn
      |> proxy_request_url()
      |> Internal.strip_uri_query()

    # The query params are added to the main params
    query_params =
      conn
      |> fetch_query_params()
      |> Map.get(:query_params, %{})

    request = %Request{
      method: conn.method,
      params: Map.merge(params, query_params),
      url: url
    }

    {:ok, request}
  end

  def parse_request(conn, :body) do
    case conn.params do
      %Conn.Unfetched{} ->
        {:error, :invalid_request}

      %{} = params ->
        url =
          conn
          |> proxy_request_url()
          |> Internal.strip_uri_query()

        # The query params are added to the main params
        query_params =
          conn
          |> fetch_query_params()
          |> Map.get(:query_params, %{})

        request = %Request{
          method: conn.method,
          params: Map.merge(params, query_params),
          url: url
        }

        {:ok, request}
    end
  end

  def parse_request(conn, :header) do
    with [hd] when is_binary(hd) <- get_req_header(conn, "authorization"),
         %{"oauth_body_hash" => _, "oauth_signature" => _} = params <-
           Internal.oauth_header_params(hd) do
      # The query params are discarded
      url =
        conn
        |> proxy_request_url()
        |> Internal.strip_uri_query()

      {:ok, %Request{method: conn.method, params: params, url: url}}
    else
      _ ->
        {:error, :invalid_request}
    end
  end

  # Get the request URL, considering any proxied request headers from a load
  # balancer
  defp proxy_request_url(%Conn{scheme: scheme} = conn) do
    final_scheme =
      case get_req_header(conn, "x-forwarded-proto") do
        [proxy_scheme | _] when proxy_scheme in ["http", "https"] -> proxy_scheme
        _ -> Atom.to_string(scheme)
      end

    conn
    |> request_url
    |> URI.parse()
    |> Map.put(:scheme, final_scheme)
    |> URI.to_string()
  end
end
