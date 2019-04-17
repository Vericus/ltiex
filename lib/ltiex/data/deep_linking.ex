defmodule Ltiex.Data.DeepLinking do
  @type t :: %__MODULE__{
          return_url: String.t(),
          accept_types: [String.t(), ...],
          accept_presentation_document_targets: [String.t(), ...],
          accept_media_types: String.t() | nil,
          accept_multiple: boolean() | nil,
          auto_create: boolean() | nil,
          text: String.t() | nil,
          data: String.t() | nil
        }
  @enforce_keys [:return_url, :accept_types, :accept_presentation_document_targets]
  defstruct [
    :accept_types,
    :accept_media_types,
    :accept_presentation_document_targets,
    :accept_multiple,
    :auto_create,
    :title,
    :text,
    :data,
    :return_url
  ]
end
