defmodule Ltiex.Data.Capabilites.Membership do
  @type t :: %__MODULE__{
          url: String.t(),
          version: String.t()
        }
  @enforce_keys [:url, :version]
  defstruct [:url, :version]

  def get_scope(%Membership{version: "2.0"}),
    do: "https://purl.imsglobal.org/spec/lti-nrps/scope/contextmembership.readonly"

  def get_scope(_), do: nil
end
