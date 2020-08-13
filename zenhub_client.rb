# frozen_string_literal: true

require "rest-client"
require "json"

class ZenHubClient
  ZENHUB_URI = "https://api.zenhub.io"

  def incomplete_issue_numbers
    res = RestClient.get("#{ZENHUB_URI}/p2/workspaces/#{ENV['WORKSPACE_ID']}/repositories/#{ENV['GITHUB_REPO_ID']}/board", headers)
    json = JSON.parse(res)
    numbers = json["pipelines"]
              .select { |pipeline| ["Backlog", "In Progress"].include? pipeline["name"] }
              .map { |pipeline| pipeline["issues"].map { |issue| issue["issue_number"] } }
    numbers.flatten
  end

private

  def headers
    { accept: "application/json", x_authentication_token: ENV["ZENHUB_TOKEN"] }
  end
end
