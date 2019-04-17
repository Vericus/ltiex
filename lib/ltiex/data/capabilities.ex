defmodule Ltiex.Data.Capabilities do
  alias Ltiex.Data.Capabilities.{GradeAssessment, Outcome, NamesRoles, DeepLinking}

  @type t :: %__MODULE__{
          outcome: Outcome.t() | nil,
          grade_assessment: GradeAssessment.t() | nil,
          names_roles: NamesRoles.t() | nil,
          deep_linking: DeepLinking.t() | nil
        }
  defstruct [:outcome, :grade_assessment, :names_roles, :deep_linking]
end
