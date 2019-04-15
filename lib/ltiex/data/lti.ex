defmodule Ltiex.Data.Lti do
  @type t :: %__MODULE__{
          version: String.t(),
          message_type: String.t(),
          deployment_id: String.t() | nil,
          message_hint: String.t() | nil,
          login_hint: String.t() | nil,
          target_link: String.t() | nil
        }
  @enforce_keys [:version, :message_type]
  defstruct [:version, :message_type, :deployment_id, :message_hint, :login_hint, :target_link]
end
