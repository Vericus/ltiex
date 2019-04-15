defmodule Ltiex.Data.Oauth do
  @type t :: %__MODULE__{
          timestamp: String.t() | Number.t(),
          nonce: String.t() | Number.t(),
          consumer_key: String.t(),
          signature_method: String.t(),
          signature: String.t(),
          version: String.t(),
          callback: String.t() | nil
        }
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
