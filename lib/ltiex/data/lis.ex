defmodule Ltiex.Data.Lis do
  @type t :: %__MODULE__{
          person_sourcedid: String.t() | nil,
          course_section_sourcedid: String.t() | nil,
          course_offering_sourcedid: String.t() | nil
        }
  defstruct [:person_sourcedid, :course_offering_sourcedid, :course_section_sourcedid]
end
