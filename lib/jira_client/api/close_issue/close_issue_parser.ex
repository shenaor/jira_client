defmodule JiraClient.Api.CloseIssueParser do

  @behaviour JiraClient.Api.Parser

  def parse(%HTTPotion.Response{body: body}) do
    parse_data Poison.Parser.parse(body)    
  end

  defp parse_data({:ok, data}) do
    {:ok, 
      %{
        issue_id: data["key"]
      }
    }
  end
end
