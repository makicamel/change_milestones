require "./load_env.rb"
require "./octokit_client.rb"
require "./zenhub_client.rb"

puts "Starting to update milestone ..."

LoadEnv.execute(test: true)
puts ".env loaded."

issue_numbers = ZenHubClient.new.incomplete_issue_numbers
puts "Target issues: #{issue_numbers.join(', ')}"

octokit = OctokitClient.new
milestone = octokit.create_milestone
puts "Milestone created. #{milestone.number}: #{milestone.title}"

issues = octokit.change_milestones(issue_numbers, milestone)
puts "Milestone updated. Target issues are ..."
issues.each { |issue| puts "  #{issue[:number]}: #{issue[:title]}" }

puts "Updating is completed. See https://github.com/#{ENV['OWNER']}/#{ENV['REPO']}/milestones"
