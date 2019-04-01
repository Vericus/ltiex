defmodule Ltiex.Internal do
  @moduledoc """
  Internal helper functions.
  """

  @doc """
  Decode OAuth params from an Authorization header string

  ## Examples

      iex> Ltiex.Internal.oauth_header_params(~s(OAuth realm="", oauth_body_hash="something"))
      %{"oauth_body_hash" => "something", "realm" => ""}

      iex> Ltiex.Internal.oauth_header_params(~s(OAuth oauth_signature="ILd%3D", oauth_version="1.0"))
      %{"oauth_signature" => "ILd=", "oauth_version" => "1.0"}

      iex> Ltiex.Internal.oauth_header_params(~s(Header something))
      nil

  """
  def oauth_header_params(header)

  def oauth_header_params("OAuth " <> header) do
    header
    |> String.replace(~r/\s?,\s?/, "&")
    |> String.replace(~s("), "")
    |> URI.decode_query()
  end

  def oauth_header_params(_), do: nil

  @doc """
  Strip the query params from a uri.

  ## Examples

      iex> Ltiex.Internal.strip_uri_query("https://google.com?q=something&foo=bar")
      "https://google.com"

      iex> Ltiex.Internal.strip_uri_query("https://localhost:4000/api/lti/?q=something")
      "https://localhost:4000/api/lti/"

  """
  @spec strip_uri_query(String.t() | URI.t()) :: String.t()
  def strip_uri_query(uri) do
    uri
    |> URI.parse()
    |> Map.put(:query, nil)
    |> URI.to_string()
  end
end
