defmodule JiraClient.Http.RequestTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias JiraClient.Http.Request
  @example_body %{field: :value, field2: %{key: :value2}}

  # TODO move definition into Http.Request
  @path "rest/api/2"

  setup do
    [creds_get_fn: fn -> Base.encode64("username:password") end]
  end

  test "Request.new", context do
    req = Request.new(:get, @example_body, @path, context[:creds_get_fn])
    req = %{req | base_url: "http://anyserver"} 

    body = @example_body

    assert req.http_method == :get
    assert req.path == @path
    assert req.headers == ["Content-Type": "application/json", "Authorization": "Basic #{Base.encode64("username:password")}"]
    assert req.body == body
    assert req.base_url == "http://anyserver"
  end

  test "request url", context do
    req = Request.new(:get, @example_body, @path, context[:creds_get_fn])
    req = %{req | base_url: "http://anyserver"} 
    assert Request.url(req) == "http://anyserver/#{@path}"
  end

  test "logging on" do
    assert "\"Hello\"\n" == capture_io fn ->
      assert "Hello" == Request.logging("Hello", true)
    end

  end

  test "logging off" do
    assert "" == capture_io fn ->
      assert "Hello" == Request.logging("Hello", false)
    end
  end
end
