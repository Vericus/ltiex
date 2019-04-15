defmodule Ltiex.Data.DeepLinking do
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
