require 'httparty'
class GithubAnalytics

  def initialize(user)
    @user = user
  end

  def commits(repo)
    data = do_request("/repos/#{@user}/#{repo}/stats/participation").parsed_response
    return present?(data["owner"]) ? sum(data["owner"]) : 0
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
      data.delete_if(&:nil?)
      data.reduce(:+)
    end

    def present?(data)
      !data.nil? || !data.empty?
    end

end