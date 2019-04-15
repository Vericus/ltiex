defmodule Ltiex.Data.Context do
  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t() | nil,
          label: String.t() | nil,
          type: [String.t(), ...] | nil
        }
  @enforce_keys [:id]
  defstruct [:id, :title, :label, :type]
end
