defmodule JiraClient.Auth.ConfigurationsTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias JiraClient.Auth.Configurations
  alias JiraClient.Utils.FileMock

  setup do
    FileMock.start_link
    :ok
  end

  test "get credentials when there are none" do
    output = capture_io fn -> Configurations.get() end

    assert Regex.match?(~r/Your credentials have not been configured/, output), "Output doesn't match expected text: '#{output}'"
  end

  test "get credentials when they exist" do
    Configurations.store(%JiraClient.Configurations{base64_encoded: "username:password"})

    assert "username:password" == Configurations.get() 
  end

  test "encode credentials" do
    assert "YWFhOmJiYg==" == Configurations.encode("aaa", "bbb")
  end

  test "init with no credentials" do
    assert %JiraClient.Configurations{errors: ["Credentials not provided"]} == Configurations.init()
  end

  test "init with an error passed in" do
    assert %JiraClient.Configurations{errors: ["Credentials not provided"]} == Configurations.init(:any, {:error, "message"})
  end

  test "init with empty strings" do
    assert %JiraClient.Configurations{errors: ["Credentials not provided"]} == Configurations.init("", "")
  end
  
  test "init with good username and password" do
    assert %JiraClient.Configurations{base64_encoded: "dXNlcm5hbWU6cGFzc3dvcmQ="} == Configurations.init("username", "password")
  end
  
end

