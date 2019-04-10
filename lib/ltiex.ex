defmodule Ltiex do
  @moduledoc """
  LTI v1.1 request signing and signature verification.

  ## Signature computation

  Most of the signature computation functions work on structs implementing the
  `Ltiex.Signable` protocol. Default implementations for the standard key-value
  `Map`, `Plug.Conn`, and `Ltiex.Request` structs are provided. Alternatively,
  the `t:Ltiex.Request.t/0` values can be created directly.

  To generate a signature on a *Signable* value, use `sign/2` directly. This
  provides both the parsed and computed signatures which can be compared. To
  also do the comparison post-computation, use `verify/2`.
  """

  alias Ltiex.Signable
  alias Ltiex.OAuth

  @type error_type :: :invalid_request | :parse_error | :signature_mismatch
  @type error :: {:error, error_type} | {:error, error_type, binary}

  @doc """
  Generate a LTI signature.

  On success, returns `{:ok, parsed, computed}`.
  """
  @spec sign(Signable.t(), binary) :: {:ok, binary, binary} | error
  def sign(signable, secret) do
    with {:ok, request} <- Signable.request(signable) do
      OAuth.signature(request, secret)
    end
  end

  @doc """
  Verify the LTI signature for a Signable value.
  """
  @spec verify(Signable.t(), binary) :: {:ok, Signable.t()} | error
  def verify(signable, secret) do
    with {:ok, parsed, computed} <- sign(signable, secret) do
      if parsed === computed do
        {:ok, signable}
      else
        {:error, :signature_mismatch}
      end
    end
  end
end
