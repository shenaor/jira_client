defmodule JiraClient.Command.CreateIssueTest do
  use JiraClient.CommonCase
  use ExUnit.Case
  doctest JiraClient.Command.CreateIssue

  alias JiraClient.Command.CreateIssue
  alias JiraClient.Args
  alias JiraClient.Http.RequestFake

  setup do
    RequestFake.init()
  end

  describe "Success" do

    test "create issue" do
      RequestFake.expect_response(~s(
        [
          {
            "self": "http://www.example.com/jira/rest/api/2/project/EX",
            "id": "10000",
            "key": "PROJECT-123",
            "name": "Example",
            "avatarUrls": {
              "48x48": "http://www.example.com/jira/secure/projectavatar?size=large&pid=10000",
              "24x24": "http://www.example.com/jira/secure/projectavatar?size=small&pid=10000",
              "16x16": "http://www.example.com/jira/secure/projectavatar?size=xsmall&pid=10000",
              "32x32": "http://www.example.com/jira/secure/projectavatar?size=medium&pid=10000"
            },
            "projectCategory": {
              "self": "http://www.example.com/jira/rest/api/2/projectCategory/10000",
              "id": "10000",
              "name": "FIRST",
              "description": "First Project Category"
            }
          }
        ]))

      RequestFake.expect_response(~s(
        {
          "id": "10000",
          "key": "ISSUE-123",
          "self": "http://www.example.com/jira/rest/api/2/issue/10000"
        }))

        {:ok, message} = CreateIssue.run(%Args{project: "Example", fix_version: "1.2.3", message: "MESSAGE 1" })

      assert "Created ISSUE-123" == message
    end
  end

  describe "failures" do

    test "no such project" do
      RequestFake.expect_response(~s(
        [
          {
            "key": "PROJECT-123",
            "name": "NO SUCH PROJECT"
          }
        ]))

        {:error, message} = CreateIssue.run(%Args{project: "Example", fix_version: "1.2.3", message: "MESSAGE 1" })

      assert "No project called 'Example'" == message
    end

    test "invalid jspn" do
      RequestFake.expect_response(~s(INVALID))

        {:error, message} = CreateIssue.run(%Args{project: "Example", fix_version: "1.2.3", message: "MESSAGE 1" })

      assert "Invalid response: 'invalid, I 0'" == message
    end
  end
end
