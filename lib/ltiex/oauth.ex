defmodule Ltiex.OAuth do
  @moduledoc """
  LTI v1.1 request signing and verification using the OAuth flavour used in the
  LTI protocol.

  OAuth Signatures are generated on a complete `t:Ltiex.Request.t/0` struct with
  a given secret. These request structs can be created directly or through
  implementing the `Ltiex.Signable` for other data types. See `Ltiex.Signable`
  for more details.
  """
  alias Ltiex.Internal
  alias Ltiex.Request

  ## API

  @doc """
  Compute the LTI signature for a request.

  On a successful signing, returns `{:ok, parsed_signature, computed_signature}`,
  which can be used for request verification through an equality comparison.
  """
  @spec signature(Request.t(), binary) :: {:ok, binary(), binary()} | {:error, :invalid_request}
  def signature(%Request{url: url, method: method, params: params}, secret)
      when is_binary(secret) do
    encoded_params = Internal.encode_lti_form(params)

    message =
      [method, url, encoded_params]
      |> Enum.map(&URI.encode_www_form/1)
      |> Enum.join("&")

    signature =
      :sha
      |> hmac(secret <> "&", message)
      |> Base.encode64()

    {:ok, Map.get(params, "oauth_signature"), signature}
  end

  def signature(_, _), do: {:error, :invalid_request}

  # Taken from :plug_crypto to accomodate :crypto's breaking change
  # TODO: remove when we require OTP 22.1
  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac(digest, key, data), do: :crypto.mac(:hmac, digest, key, data)
  else
    defp hmac(digest, key, data), do: :crypto.hmac(digest, key, data)
  end
end
