# frozen_string_literal: true

require "octokit"

class OctokitClient
  def issues
    number = client.milestones(repo).select do |milestone|
      milestone.title.start_with? ENV["PREFIX"]
    end.first.number

    client.issues(repo, milestone: number).each(&:title)
  end

  def milestone
    client.milestones(repo).select do |milestone|
      milestone.title.start_with? ENV["PREFIX"]
    end.first
  end

  def create_milestone
    title = "SEC_#{Date.today.strftime('%Y%m%d')}"
    params = {
      "title" => title,
      "state" => "open",
      "description" => "",
      "due_on" => (Date.today + 4).strftime("%FT%R:00Z")
    }
    client.create_milestone(repo, title, params)
  end

  def change_milestones(issue_numebrs, milestone)
    issue_numebrs.map do |issue_number|
      client.update_issue(repo, issue_number, milestone: milestone.number)
    end
  end

private

  def client
    @client ||= Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  end

  def repo
    "#{ENV['OWNER']}/#{ENV['REPO']}"
  end
end
