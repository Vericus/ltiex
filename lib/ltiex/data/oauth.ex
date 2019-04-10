defmodule Ltiex.Data.Oauth do
  @enforce_keys [:timestamp, :nonce, :consumer_key, :signature_method, :signature, :version]
  defstruct [
    :timestamp,
    :nonce,
    :consumer_key,
    :signature_method,
    :signature,
    :version,
    :callback
  ]
end
