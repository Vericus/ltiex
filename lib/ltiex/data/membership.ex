defmodule Ltiex.Data.Membership do
  @type t :: %__MODULE__{
          url: String.t(),
          version: String.t()
        }
  @enforce_keys [:url, :version]
  defstruct [:url, :version]
end
