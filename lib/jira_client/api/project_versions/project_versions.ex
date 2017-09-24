defmodule JiraClient.Api.ProjectVersions do
  @moduledoc """
    Send the formatted project versions command to the JIRA server and return the json response.
  """

  @request Application.get_env(:jira_client, :request_module, JiraClient.Http.Request)

  @behaviour JiraClient.Api.Sender

  # GET /rest/api/2/project/{projectIdOrKey}/versions
  @spec send(%{project_id: String.t}, String.t) :: {Atom.t, Sring.t}
  def send(attributes, body) do
    response = @request.new(:get, body, "rest/api/latest/project/#{attributes.project_id}/versions")
    |> @request.send

    {:ok, response}
  end
end
