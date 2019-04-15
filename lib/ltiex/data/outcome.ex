defmodule Ltiex.Data.Outcome do
  @type t :: %__MODULE__{
          url: String.t(),
          version: String.t(),
          basic: Boolean.t()
        }
  @enforce_keys [:url]
  defstruct [:url, :version, basic: true]
end
