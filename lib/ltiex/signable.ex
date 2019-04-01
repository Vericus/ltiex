defprotocol Ltiex.Signable do
  @moduledoc """
  Protocol used as a base for generating LTI signatures.

  Implement this protocol for structs from which an `Ltiex.Request.t` struct can
  be parsed. The `Ltiex.Request.t` struct validates all the required information
  is present for generating an OAuth LTI signature.

  ## Available Implementations

  The library implements this protocol for a Map, the Request struct itself, and
  the `Plug.Conn.t` struct. 

  ### `Map`

  A map is signable if it has the keys needed in a `%Request{}`. A basic runtime
  type check is performed for the values.

  ### `Ltiex.Request`

  An identity implementation.

  ### `Plug.Conn`

  The Signable implementation for `t:Plug.Conn.t/0` is useful for verifying
  incoming LTI requests.

  The `:method` value is picked directly from the parent `Conn` value.

  The `:params` map is either extracted from the fetched `Conn` body and query or
  the request headers depending on the `content-type` request header value:

  * If the `content-type` request header is one of `application/xml` or
    `application/json`, the LTI params are parsed from the OAuth `authorization`
    header: For example: 

    ```http
    Content-Type: application/xml
    Authorization: OAuth realm="",oauth_signature="...",oauth_body_hash=".."
    ```
    
    For such a request, the keys `oauth_signature` and `oauth_body_hash` are
    required. The query params are discarded.

  * If the `content-type` request header is `x-www-form-urlencoded` or the Conn
    body params are fetched and available as a map, the LTI params are parsed
    from that directly. Additionally, the URL query params are merged with the
    body params.

  The `url` value is computed using `Plug.Conn.request_url/1`. Additionally if
  there is a request header `x-forwarded-proto` present which provides the
  actual request scheme (usually from the load balancer), it will be used
  instead of the Conn's `:scheme`.

  """
  @type t :: Signable.t()

  @doc """
  Extract a `Ltiex.Request` struct from the underlying struct.

  Should return `{:ok, request_struct}` on success or fail with any error tuple.
  """
  @spec request(t) :: {:ok, Ltiex.Request.t()} | {:error, term}
  def request(signable)
end

defimpl Ltiex.Signable, for: Map do
  alias Ltiex.Request

  def request(%{"params" => ps, "url" => url, "method" => m})
      when is_map(ps) and is_binary(url) and m in ["POST", "GET"] do
    {:ok, %Request{params: ps, url: url, method: m}}
  end

  def request(%{params: ps, url: url, method: m})
      when is_map(ps) and is_binary(url) and m in ["POST", "GET"] do
    {:ok, %Request{params: ps, url: url, method: m}}
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
