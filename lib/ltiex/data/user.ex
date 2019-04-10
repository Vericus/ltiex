defmodule Ltiex.Data.User do
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
