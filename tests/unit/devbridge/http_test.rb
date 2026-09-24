# frozen_string_literal: true

require 'test_helper'
require_devbridge 'http'

class DevBridgeHttpTest < Minitest::Test

  Http = MuriloEduardoDev::DevBridge::Http
  MAX_BODY = 1024

  def raw_request(body = 'puts 1', headers = {})
    lines = ['POST /eval?x=1 HTTP/1.1', "Content-Length: #{body.bytesize}", 'X-Dev-Token: t']
    headers.each { |name, value| lines << "#{name}: #{value}" }
    "#{lines.join("\r\n")}\r\n\r\n#{body}"
  end

  def test_incomplete_without_header_end
    refute(Http.complete?('POST /eval HTTP/1.1', max_body: MAX_BODY))
  end

  def test_incomplete_until_body_arrives
    refute(Http.complete?(raw_request('12345')[0...-2], max_body: MAX_BODY))
  end

  def test_complete_with_full_body
    assert(Http.complete?(raw_request('12345'), max_body: MAX_BODY))
  end

  def test_oversized_body_raises
    assert_raises(Http::PayloadTooLarge) { Http.complete?(raw_request('x' * 2000), max_body: MAX_BODY) }
  end

  def test_parse_request
    request = Http.parse(raw_request('puts 1'), max_body: MAX_BODY)

    assert_equal('POST', request.http_method)
    assert_equal('/eval', request.path)
    assert_equal({ 'x' => '1' }, request.query)
    assert_equal('t', request.headers['x-dev-token'])
    assert_equal('puts 1', request.body)
  end

  def test_parse_rejects_malformed_request_line
    assert_raises(Http::BadRequest) { Http.parse("GARBAGE\r\n\r\n", max_body: MAX_BODY) }
  end

  def test_response_has_json_body_and_length
    response = Http.response(200, { ok: true })

    assert(response.start_with?("HTTP/1.1 200 OK\r\n"))
    assert_includes(response, "Content-Length: 11\r\n")
    assert(response.end_with?('{"ok":true}'))
  end

end
