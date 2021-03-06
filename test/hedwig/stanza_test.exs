defmodule Hedwig.StanzaTest do
  use ExUnit.Case, async: true
  use Hedwig.XML

  alias Hedwig.Stanza

  doctest Hedwig.Stanza

  test "start_stream with default xmlns" do
    assert Stanza.start_stream("im.wonderland.lit") |> Stanza.to_xml ==
      "<stream:stream xmlns:stream='#{ns_xmpp}' xmlns='jabber:client' xml:lang='en' version='1.0' to='im.wonderland.lit'>"
  end

  test "start_stream with 'jabber:server' xmlns" do
    assert Stanza.start_stream("im.wonderland.lit", ns_jabber_server) |> Stanza.to_xml ==
      "<stream:stream xmlns:stream='http://etherx.jabber.org/streams' xmlns='jabber:server' xml:lang='en' version='1.0' to='im.wonderland.lit'>"
  end

  test "end_stream" do
    assert Stanza.end_stream |> Stanza.to_xml == "</stream:stream>"
  end

  test "start_tls" do
    assert Stanza.start_tls |> Stanza.to_xml ==
      "<starttls xmlns='#{ns_tls}'/>"
  end

  test "compress" do
    assert Stanza.compress("zlib") |> Stanza.to_xml ==
      "<compress xmlns='#{ns_compress}'><method>zlib</method></compress>"
  end

  test "auth" do
    data = <<0>> <> "username" <> <<0>> <> "password"
    assert Stanza.auth("PLAIN", Stanza.base64_cdata(data)) |> Stanza.to_xml ==
      "<auth mechanism='PLAIN' xmlns='#{ns_sasl}'>AHVzZXJuYW1lAHBhc3N3b3Jk</auth>"
  end

  test "bind" do
    assert Stanza.bind("hedwig") |> Stanza.to_xml =~
      ~r"<iq id='(.*)' type='set'><bind xmlns='#{ns_bind}'><resource>hedwig</resource></bind></iq>"
  end

  test "session" do
    assert Stanza.session |> Stanza.to_xml =~
      ~r"<iq id='(.*)' type='set'><session xmlns='#{ns_session}'/></iq>"
  end

  test "presence" do
    assert Stanza.presence |> Stanza.to_xml == "<presence/>"
  end

  test "message" do
    assert Stanza.message("test@localhost", "chat", "Hello") |> Stanza.to_xml =~
      ~r"<message xml:lang='en' id='(.*)' type='chat' to='test@localhost'><body>Hello</body></message>"
  end
end
