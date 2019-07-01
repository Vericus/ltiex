defmodule LtiexTest do
  use ExUnit.Case, async: true
  use Plug.Test

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

    {:ok, req} = Ltiex.Signable.request(test_conn)
    assert req.url === @uri
    assert {:ok, ^signature, ^signature} = Ltiex.sign(test_conn, @secret)
    assert {:ok, ^test_conn} = Ltiex.verify(test_conn, @secret)
  end

  test "Computed LTI request URL is the same as the request URL" do
    # If a request is proxied from the original HTTPs request  
    test_conn =
      :post
      |> conn("http://api.domain.io/test/lti/launch")
      |> put_req_header("x-forwarded-proto", "https")

    # The url should not contain port
    {:ok, req} = Ltiex.Signable.request(test_conn)
    assert req.url === "https://api.domain.io/test/lti/launch"
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

    assert {:error, :parse_error, "missing oauth params"} = Ltiex.sign(test_conn, @secret)

    # No Oauth signature
    header =
      ~s(OAuth realm="",oauth_body_hash="nEcbliPSslBHFGDMMuwSHrCIQNM%3D",oauth_consumer_key="5b8e17f4cb083",oauth_nonce="NDZaL2ZHb0treU5ka3N4WFg4RlhhQT09",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1536196729",oauth_version="1.0")

    test_conn =
      :post
      |> conn(@uri)
      |> put_req_header("content-type", "application/xml")
      |> put_req_header("authorization", header)

    assert {:error, :parse_error, "missing oauth params"} = Ltiex.sign(test_conn, @secret)
  end
end
