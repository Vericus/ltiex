defmodule Ltiex.Data do
  @type t :: %__MODULE__{
          context: Ltiex.Data.Context.t() | nil,
          launch_presentation: Ltiex.Data.LaunchPresentation.t() | nil,
          lti: Ltiex.Data.Lti.t() | nil,
          resource: Ltiex.Data.Resource.t() | nil,
          tool: Ltiex.Data.Tool.t() | nil,
          user: Ltiex.Data.User.t() | nil,
          capabilities: Ltiex.Data.Capabilities.t() | nil,
          ext: Map.t() | nil,
          custom: Map.t() | nil,
          extras: Map.t() | nil
        }
  defstruct [
    :context,
    :launch_presentation,
    :lis,
    :lti,
    :resource,
    :tool,
    :user,
    :capabilities,
    :ext,
    :custom,
    :extras
  ]

  def serialize(%{}, opts \\ []) do
    {serializer, opts} = Keyword.pop(opts, :serializer)
  end

  def deserialize(request, opts \\ []) do
    {serializer, opts} = Keyword.pop(opts, :serializer)
  end

  def is_valid(%Data{}) do
  end
end
