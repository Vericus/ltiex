defmodule Ltiex.OAuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Ltiex.OAuth

  @uri "http://localhost:5000/api/lti/1p0/outcome"
  @secret "5b8e17f4cb083"

  test "signature for application/xml requests" do
    header =
      ~s(OAuth realm="",oauth_body_hash="nEcbliPSslBHFGDMMuwSHrCIQNM%3D",oauth_consumer_key="5b8e17f4cb083",oauth_nonce="NDZaL2ZHb0treU5ka3N4WFg4RlhhQT09",oauth_signature="ILdPpQeR0MX0gjY53O6sxKAJ4iY%3D",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1536196729",oauth_version="1.0")

    signature = "ILdPpQeR0MX0gjY53O6sxKAJ4iY="

    test_conn =
      :post
      |> conn(@uri)
      |> put_req_header("content-type", "application/xml")
      |> put_req_header("authorization", header)

    assert {:ok, ^signature, ^signature} = OAuth.signature(test_conn, @secret)
  end

  test "rejects malformed application/xml message headers" do
    # No body hash
    header =
      ~s(OAuth realm="",oauth_consumer_key="5b8e17f4cb083",oauth_nonce="NDZaL2ZHb0treU5ka3N4WFg4RlhhQT09",oauth_signature="ILdPpQeR0MX0gjY53O6sxKAJ4iY%3D",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1536196729",oauth_version="1.0")

    test_conn =
      :post
      |> conn(@uri)
      |> put_req_header("content-type", "application/xml")
      |> put_req_header("authorization", header)

    assert {:error, :invalid_request} = OAuth.signature(test_conn, @secret)

    # No Oauth signature
    header =
      ~s(OAuth realm="",oauth_body_hash="nEcbliPSslBHFGDMMuwSHrCIQNM%3D",oauth_consumer_key="5b8e17f4cb083",oauth_nonce="NDZaL2ZHb0treU5ka3N4WFg4RlhhQT09",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1536196729",oauth_version="1.0")

    test_conn =
      :post
      |> conn(@uri)
      |> put_req_header("content-type", "application/xml")
      |> put_req_header("authorization", header)

    assert {:error, :invalid_request} = OAuth.signature(test_conn, @secret)
  end
end
