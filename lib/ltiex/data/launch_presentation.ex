defmodule Ltiex.Data.LaunchPresentation do
  @type t :: %__MODULE__{
          document_target: :iframe | :window,
          locale: String.t() | nil,
          height: Number.t() | nil,
          width: Number.t() | nil,
          return_url: String.t() | nil,
          css_url: String.t() | nil
        }
  @enforce_keys [:return_url]
  defstruct [:document_target, :locale, :height, :width, :return_url, :css_url]
end
