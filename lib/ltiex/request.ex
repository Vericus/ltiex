defmodule Ltiex.Request do
  @moduledoc """
  Normalised LTI request struct.
  """
  @type t :: %__MODULE__{url: String.t(), method: String.t(), params: map}
  defstruct [:url, :method, :params]
end

defimpl Ltiex.Signable, for: Ltiex.Request do
  def request(r), do: {:ok, r}
end
