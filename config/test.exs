use Mix.Config
Code.require_file("lib/jira_client/http/request.ex")
Code.require_file("test/jira_client/http/request_fake.ex")

config :jira_client, 
  base_url:         "https://vpsadm.ipcoop.com/jira",
  credentials_module: JiraClient.Auth.CredentialsMock,
  command_module:   JiraClientTest.CommandFake,
  request_module:   JiraClient.Http.RequestFake,
  file_module:      JiraClient.Utils.FileMock

