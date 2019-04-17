defmodule Ltiex.Parser do
  @moduledoc """
  Defines the contract to parse/build LTI request
  """

  @doc """
  Parse the given LTI.Signable object.

  Returns `{:ok, data}` if successfull or `{:error, msg}` if it fails
  """
  @callback parse(request :: Ltiex.Signable.t()) :: {:ok, Ltiex.Data.t()} | {:error, String.t()}

  @doc """
  build an LTI request given LTI's data

  Returns `{:ok, request}` if successfull or `{:error, msg}` if it fails
  """
  @callback build(data :: LtiEx.Data.t()) :: {:ok, Ltiex.Request.t()} | {:error, String.t()}

  @callback version() :: String.t()
  @callback message_type() :: String.t()

  def parse(request, serializer), do: serializer.parse(request)
  def build(data, serializer), do: serializer.build(data)
end
