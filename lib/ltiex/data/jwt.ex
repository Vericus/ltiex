defmodule Ltiex.Data.Jwt do
  """
  https://www.imsglobal.org/spec/security/v1p0/
  """

  defstruct [:iss, :sub, :aud, :iat, :exp, :jti, :alg, :azp, :nonce, :scope]
end
