defmodule JiraClient.Api.GetTransitionsParserTest do
  use ExUnit.Case

  alias JiraClient.Api.GetTransitionsParser

  test "parse response" do
    json = ~s({
      "transitions": [
        {
          "id": "2",
          "name": "Close Issue",
          "to": {
            "self": "http://localhost:8090/jira/rest/api/2.0/status/10000",
            "description": "The issue is currently being worked on.",
            "iconUrl": "http://localhost:8090/jira/images/icons/progress.gif",
            "name": "In Progress",
            "id": "10000",
            "statusCategory": {
              "self": "http://localhost:8090/jira/rest/api/2.0/statuscategory/1",
              "id": 1,
              "key": "in-flight",
              "colorName": "yellow",
              "name": "In Progress"
            }
          },
          "hasScreen": false,
          "isGlobal": false,
          "isInitial": false,
          "isConditional": false,
          "fields": {
            "summary": {
              "required": false,
              "schema": {
                "type": "array",
                "items": "option",
                "custom": "com.atlassian.jira.plugin.system.customfieldtypes:multiselect",
                "customId": 10001
              },
              "name": "My Multi Select",
              "key": "field_key",
              "hasDefaultValue": false,
              "operations": [
                "set",
                "add"
              ],
              "allowedValues": [
                "red",
                "blue"
              ],
              "defaultValue": "red"
            }
          }
        },
        {
          "id": "711",
          "name": "QA Review",
          "to": {
            "self": "http://localhost:8090/jira/rest/api/2.0/status/5",
            "description": "The issue is closed.",
            "iconUrl": "http://localhost:8090/jira/images/icons/closed.gif",
            "name": "Closed",
            "id": "5",
            "statusCategory": {
              "self": "http://localhost:8090/jira/rest/api/2.0/statuscategory/9",
              "id": 9,
              "key": "completed",
              "colorName": "green"
            }
          },
          "hasScreen": true,
          "fields": {
            "summary": {
              "required": false,
              "schema": {
                "type": "array",
                "items": "option",
                "custom": "com.atlassian.jira.plugin.system.customfieldtypes:multiselect",
                "customId": 10001
              },
              "name": "My Multi Select",
              "key": "field_key",
              "hasDefaultValue": false,
              "operations": [
                "set",
                "add"
              ],
              "allowedValues": [
                "red",
                "blue"
              ],
              "defaultValue": "red"
            },
            "colour": {
              "required": false,
              "schema": {
                "type": "array",
                "items": "option",
                "custom": "com.atlassian.jira.plugin.system.customfieldtypes:multiselect",
                "customId": 10001
              },
              "name": "My Multi Select",
              "key": "field_key",
              "hasDefaultValue": false,
              "operations": [
                "set",
                "add"
              ],
              "allowedValues": [
                "red",
                "blue"
              ],
              "defaultValue": "red"
            }
          }
        }
      ]
    })

    {:ok, response} = GetTransitionsParser.parse(%HTTPotion.Response{body: json})
    
    transition = List.first(response)
    assert transition.id == "2"
    assert transition.name == "Close Issue"

    transition = List.last(response)
    assert transition.id == "711"
    assert transition.name == "QA Review"
  end

  test "bad list of transitions" do
    assert {:error, "No transitions"} == GetTransitionsParser.parse(%HTTPotion.Response{body: "{}"})
    assert {:error, "No transitions"} == GetTransitionsParser.parse(%HTTPotion.Response{body: "{transitions:[]}"})
  end

  test "invalid json response" do
    assert {:error, "No transitions"} == GetTransitionsParser.parse(%HTTPotion.Response{body: "Invalid JSON"})
  end
end

