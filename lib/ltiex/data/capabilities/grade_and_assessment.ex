defmodule Ltiex.Data.Capabilities.GradeAssessment do
  @type t :: %__MODULE__{
          scope: [String.t(), ...],
          line_items: String.t() | nil,
          line_item: String.t() | nil
        }
  defstruct [:scope, :line_item, :line_items]
end
