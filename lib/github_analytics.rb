require 'httparty'
class GithubAnalytics

  def initialize(user)
    @user = user
  end

  def commits(repo)
    data = do_request("/repos/#{@user}/#{repo}/stats/participation")
    if data.nil? || data["owner"].nil?
      0
    else
      sum(data['owner'])
    end
  end

  def repos
    @repos ||= do_request("/users/#{@user}/repos").parsed_response.map { |repo| repo['name'] }
  end

  def total_commits
    sum(repos.map { |repo| commits(repo) } )
  end

  protected

    def do_request(method=:get, uri)
      HTTParty.get("https://api.github.com#{uri}?access_token=#{ENV['GITHUB_TOKEN']}", :headers=>{"User-Agent" => "tspaulino"})
    end

    def sum(data)
      data.reduce(:+)
    end
end