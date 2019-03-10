defmodule JiraClient.Command.Help do
  def run(_) do
    {:ok, ~s(usage: jira_client [command] [arguments]

      Commands:
      configure --username "esumerfield"
      list_projects
      create_issue --project "PROJECT A" --message "this is an issue" [--fixVersion "1.2.3"] [--logging]
      close_issue --issue "ABC-123" [--logging]
    )}
  end
end

