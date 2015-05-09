require 'github_api'

class GithubAnalytics

  def initialize(user)
    @user, @repos= user, nil
  end

  def repo_commits(repo)
    sum(client.repos.stats.commit_activity(user: @user, repo: repo).map{ |response|
      if response.respond_to?(:total) and !response.total.nil?
        response.total
      else
        0
      end
    })
  end

  def total_commits
    commits = []
    @repos = load_repos(@user) if @repos.nil?
    @repos.each { |repo|
      commits << repo_commits(repo)
    }
    sum(commits)
  end

  protected

    def load_repos(user)
      client.repos.list(user: user).map(&:name)
    end

    def client
      Github.new oauth_token: "34dede9420a069a2507cd6e611a61faf047e5216"
    end

    def sum(data)
      data.reduce(:+)
    end
end