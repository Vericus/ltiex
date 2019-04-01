defmodule Ltiex do
  @moduledoc """
  LTI v1.1 request signing and signature verification.

  ## Signature computation

  Most of the functions work with structs implmenting the `Ltiex.Signable`
  protocol. Implmentations for a standard key-value `Map`, `Plug.Conn`, and
  `Ltiex.Request` structs are provided. Alternatively, the `t:Ltiex.Request.t/0`
  values can be created directly.

  To generate a signature on a *Signable* value, use `sign/2` directly. This
  provides both the parsed and computed signatures which can be compared. To
  also do the comparison post-computation, use `verify/2`.
  """

  alias Ltiex.Signable
  alias Ltiex.OAuth

  @doc """
  Generate a LTI signature.

  On success, returns `{:ok, parsed, computed}`.
  """
  @spec sign(Signable.t(), String.t()) :: {:ok, String.t(), String.t()} | {:error, term}
  def sign(signable, secret) do
    with {:ok, request} <- Signable.request(signable) do
      OAuth.signature(request, secret)
    end
  end

  @doc """
  Verify the LTI signature for a Signable value.
  """
  @spec verify(Signable.t(), String.t()) ::
          {:ok, Signable.t()} | {:error, :signature_mismatch} | {:error, term}
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
