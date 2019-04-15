defmodule Ltiex.Data.Resource do
  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          description: String.t()
        }
  @enforce_keys [:id]
  defstruct [:id, :title, :description]
end
