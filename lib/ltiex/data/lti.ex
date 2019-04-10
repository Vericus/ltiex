defmodule Ltiex.Data.Lti do
  @enforce_keys[:version, :message_type]
  defstruct[:version, :message_type, :locale, :deployment_id, :message_hint, :login_hint, :target_link]
end
