defmodule Ltiex do
  @moduledoc """
  Documentation for Ltiex.
  """

  alias Ltiex.Signable
  alias Ltiex.OAuth

  @doc """
  Generate LTI signature.
  """
  @spec sign(Signable.t(), String.t()) :: {:ok, String.t(), String.t()} | {:error, term}
  def sign(signable, secret) do
    with {:ok, request} <- Signable.request(signable) do
      OAuth.signature(request, secret)
    end
  end

  @doc """
  Compute and verify signature.
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
