defmodule Ltiex.Request do
  @moduledoc """
  Normalised LTI request containing all the keys required to generate an OAuth
  digest for signing.
  """
  @enforce_keys [:url, :method, :params]
  @type t :: %__MODULE__{url: String.t(), method: String.t(), params: map}
  defstruct [:url, :method, params: %{}]
end

defimpl Ltiex.Signable, for: Ltiex.Request do
  def request(r), do: {:ok, r}
end
