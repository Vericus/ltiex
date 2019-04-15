defmodule Ltiex.Data.Tool do
  @type t :: %__MODULE__{
          guid: String.t() | nil,
          version: String.t() | nil,
          name: String.t() | nil,
          contact_email: String.t() | nil,
          description: String.t() | nil,
          url: String.t() | nil,
          product_family_code: String.t() | nil
        }
  defstruct [:guid, :version, :name, :contact_email, :description, :url, :product_family_code]
end
