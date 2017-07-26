defmodule JiraClient.ArgsTest do
  use ExUnit.Case
  #doctest JiraClient.Args
  alias JiraClient.Args

  # {[project: "PROJECT ONE", fixVersion: "1.2.3.4", issue: "XXX-123"], ["create_issue"], []}
  test "create_issue all args" do
    {:ok, args} = Args.parse(["create_issue", "--project", "PROJECT ONE", "--fixVersion", "1.2.3.4", "--message", "message"])

    assert "create_issue" == args.command
    assert "PROJECT ONE" == args.project
    assert "1.2.3.4" == args.fix_version
  end

  test "create_issue all aliases" do
    {:ok, args} = Args.parse(["create_issue", "-p", "PROJECT ONE", "-f", "1.2.3.4", "-m", "message"])

    assert "create_issue" == args.command
    assert "PROJECT ONE" == args.project
    assert "1.2.3.4" == args.fix_version
  end

  test "close_issue all args" do
    {:ok, args} = Args.parse(["close_issue", "--issue", "XXX-123"])

    assert "XXX-123" == args.issue
  end

  test "close_issue all aliases" do
    {:ok, args} = Args.parse(["close_issue", "-i", "XXX-123"])

    assert "XXX-123" == args.issue
  end

  test "invalid arguments" do
    assert {:error, "invalid arguments: {\"--invalid\", nil}"} == Args.parse(["--invalid"])
  end

  test "no command" do
    assert {:error, "missing command"} == Args.parse(["--project", "PROJECT ONE"])
  end

  test "create_issue missing argument" do
    assert {:error, "missing arguments for create_issue command"} == Args.parse(["create_issue", "--project", "PROJECT ONE", "--fixVersion", "1.2.3.4"]) # missing message
    assert {:error, "missing arguments for create_issue command"} == Args.parse(["create_issue", "--fixVersion", "1.2.3.4", "--message", "message"])     # missing project
    assert {:error, "missing arguments for create_issue command"} == Args.parse(["create_issue", "--project", "PROJECT ONE", "--message", "message"])    # missing fix version
  end

  test "close_issue missing argument" do
    assert {:error, "missing arguments for close_issue command"} == Args.parse(["close_issue"]) # missing issue
  end

end
