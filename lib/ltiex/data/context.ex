defmodule Ltiex.Data.Context do
  @enforce_keys [:id]
  defstruct[:id, :title, :label, :type]
end
