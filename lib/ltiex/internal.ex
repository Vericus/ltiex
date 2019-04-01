defmodule Ltiex.Internal do
  @moduledoc """
  Internal Helper functions.
  """

  @doc """
  Decode OAuth params in an Authorization header.
  """
  def parse_oauth_params("OAuth " <> header) do
    header
    |> String.replace(~r/\s?,\s?/, "&")
    |> String.replace(~s("), "")
    |> URI.decode_query()
  end

  def parse_oauth_params(_), do: nil

  @doc """
  Strip the query params from a uri.
  """
  @spec strip_uri_query(String.t() | URI.t()) :: String.t()
  def strip_uri_query(uri) do
    uri
    |> URI.parse()
    |> Map.put(:query, nil)
    |> URI.to_string()
  end
end
