defmodule Ltiex.Data.User do
  @type t :: %__MODULE__{
          id: String.t(),
          full_name: String.t() | nil,
          given_name: String.t() | nil,
          middle_name: String.t() | nil,
          family_name: String.t() | nil,
          email: String.t() | nil,
          image: String.t() | nil,
          roles: [String.t(), ...],
          role_scope_mentor: [String.t()] | nil
        }
  @enforce_keys [:id]
  defstruct [
    :id,
    :full_name,
    :given_name,
    :middle_name,
    :family_name,
    :email,
    :image,
    :roles,
    :role_scope_mentor
  ]
end
