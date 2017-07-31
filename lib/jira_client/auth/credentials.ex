defmodule JiraClient.Auth.Credentials do
  @behaviour JiraClient.Credentials

  alias JiraClient.Credentials, as: Creds
  alias JiraClient.Utils.FileUtils
  @moduledoc """
  This module contains functions for authenticating with the Jira
  Api using basic authentication
  """
  @base Path.expand("~")
  @cred_file_path Path.join(@base, ".jira/credentials.txt")

  def init(), do: build_credentials(nil)
  def init("", ""), do: build_credentials(nil)
  def init(username, pass) do
    "#{username}:#{pass}"
    |> Base.encode64()
    |> build_credentials()
    |> store()
  end

  def get(file \\ @cred_file_path) do
    with true <- File.exists?(file),
      {:ok, creds} <- File.read(file)
    do
      String.trim(creds)
    else
      false -> get_credentials()
      {:error, reason} ->
        IO.puts "Something went wrong: #{reason}"
    end
  end

  def store(%Creds{errors: errors}) when length(errors) > 0 do
     IO.puts "There is an error or errors with your credentials:\n#{for error <- errors, do: IO.inspect(error)}"
     IO.puts "Please try again."
     get()
  end

  def store(%Creds{base64_encoded: encoded} = creds) do
    FileUtils.mkdir_for_credentials()
    FileUtils.write_credentials(encoded)
    creds
  end

  defp get_credentials do
    IO.puts "Please provide your username and password."
    init(get_username(), get_password())
  end

  defp get_username do
    IO.gets "Username: " |> String.trim()
  end

  defp get_password do
    IO.gets "Password: " |> String.trim()
  end

  defp build_credentials(nil), do: %Creds{errors: ["Credentials not provided"]}
  defp build_credentials(encoded_credentials) do
    %Creds{base64_encoded: encoded_credentials}
  end
end
