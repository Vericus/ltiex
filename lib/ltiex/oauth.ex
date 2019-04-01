defmodule Ltiex.OAuth do
  @moduledoc """
  LTI v1.1 request signing and verification using the OAuth flavour used in the
  LTI protocol.

  OAuth Signatures are generated on a complete `t:Ltiex.Request.t/0` struct with
  a given secret. These request structs can be created directly or through
  implementing the `Ltiex.Signable` for other data types. See `Ltiex.Signable`
  for more details.
  """
  alias Ltiex.Request

  @exclude_params ["format", "realm", "oauth_signature"]

  ## API

  @doc """
  Compute the LTI signature for a request.

  On a successful signing, returns {:ok, parsed_signature, computed_signature},
  which can be used for request verification through an equality comparison.
  """
  @spec signature(Request.t(), String.t()) :: {:ok, String.t(), String.t()} | {:error, term}
  def signature(%Request{url: url, method: method, params: params}, secret) do
    with {:ok, encoded_params} <- encode_params(params) do
      message =
        [method, url, encoded_params]
        |> Enum.map(&URI.encode_www_form/1)
        |> Enum.join("&")

      signature =
        :sha
        |> :crypto.hmac(secret <> "&", message)
        |> Base.encode64()

      {:ok, Map.get(params, "oauth_signature"), signature}
    end
  end

  ## Internal

  # Encode the given request params as per LTI encoding rules, preparing a
  # single combined string.
  defp encode_params(params) do
    encoded =
      params
      |> Enum.filter(&(!Enum.member?(@exclude_params, elem(&1, 0))))
      |> Enum.map(&encode_param!/1)
      |> Enum.map(&normalize_spaces/1)
      |> Enum.sort()
      |> Enum.join("&")

    {:ok, encoded}
  rescue
    _e in RuntimeError -> {:error, :invalid_param}
  end

  # Encode and combine a {key, value} param tuple.
  defp encode_param!({key, value}) when key != nil and value != nil do
    encoded_value =
      value
      |> ensure_string()
      |> URI.encode_www_form()

    "#{key}=#{encoded_value}"
  end

  defp encode_param!(_), do: raise("invalid param")

  defp ensure_string(x) when is_integer(x), do: Integer.to_string(x)
  defp ensure_string(x) when is_float(x), do: Float.to_string(x)
  defp ensure_string(x) when is_binary(x), do: x
  defp ensure_string(_), do: raise("invalid param")

  # Replace '+' characters with the actual percent encoding value: '%20'
  # This has to be done has Elixir's `URI.encode_www_form` encodes spaces as
  # '+', instead of the old percent encoded '%20' character.
  defp normalize_spaces(str) do
    Regex.replace(~r/\+/, str, "%20")
  end
end
