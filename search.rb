 #!/usr/bin/env ruby
require './lib/github_analytics.rb'

total_users = []
ARGV.each do |user|
  total_users << { user: user, commits: GithubAnalytics.new(user).total_commits }
end
total_users.sort! { |a, b| b[:commits] <=> a[:commits] }
total_users.each do |stat|
  puts "#{stat[:user]} - #{stat[:commits]}"
end