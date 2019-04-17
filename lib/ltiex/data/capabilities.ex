defmodule Ltiex.Data.Capabilities do
  alias Ltiex.Data.Capabilities.{GradeAssessment, Outcome, Membership}

  @type t :: %__MODULE__{
          outcome: Outcome.t() | nil,
          grade_assessment: GradeAssessment.t() | nil,
          membership: Membership.t() | nil
        }
  defstruct [:outcome, :grade_assessment, :membership]
end
