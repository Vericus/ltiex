defmodule Ltiex.Data.Capabilities.Outcome do
  @type t :: %__MODULE__{
          url: String.t(),
          version: String.t()
        }
  @enforce_keys [:url]
  defstruct [:url, :version]
end
