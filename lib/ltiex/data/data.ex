defmodule Ltiex.Data do
  @type t :: %__MODULE__{
          context: Ltiex.Data.Context.t() | nil,
          jwt: Ltiex.Data.Jwt.t() | nil,
          launch_presentation: Ltiex.Data.LaunchPresentation.t() | nil,
          lti: Ltiex.Data.Lti.t() | nil,
          membership: Ltiex.Data.Membership.t() | nil,
          oauth: Ltiex.Data.Oauth.t(),
          outcome: Ltiex.Data.Outcome.t() | nil,
          resource: Ltiex.Data.Resource.t() | nil,
          tool: Ltiex.Data.Tool.t() | nil,
          user: Ltiex.Data.User.t() | nil,
          ext: Map.t() | nil,
          custom: Map.t() | nil
        }
  defstruct [
    :context,
    :jwt,
    :launch_presentation,
    :lis,
    :lti,
    :membership,
    :oauth,
    :outcome,
    :resource,
    :tool,
    :user,
    :ext,
    :custom
  ]

  def serialize(%{}, opts \\ []) do
    {serializer, opts} = Keyword.pop(opts, :serializer)
  end

  def deserialize(request, opts \\ []) do
    {serializer, opts} = Keyword.pop(opts, :serializer)
  end
end
