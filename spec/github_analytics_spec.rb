require 'spec_helper'

RSpec.describe GithubAnalytics do

  before do
    @client = Github.new
    allow_any_instance_of(GithubAnalytics).to receive(:client).and_return(@client)
    @subject = GithubAnalytics.new(user: 'foo')
    allow(@subject).to receive(:client).and_return(@client)
    allow(@client).to receive(:load_repos).and_return([{name: 'foo_repo'}])
  end


  describe "#initialize" do
    it "returns a valid instance with the valid attributes" do
      expect(@subject).to be_a(GithubAnalytics)
    end
  end

  describe "#repo_commits" do
    context "for a repository with valid commits" do
      it "returns the total of commits for all public repositories for the given user" do
        allow(@subject).to receive_message_chain("client.repos.stats.commit_activity").and_return([double(Object, total: 10)])
        expect(@subject.repo_commits('foo')).to eq(10)
      end
    end

    context "for a repository without commits" do
      it "returns 0" do
        allow(@subject).to receive_message_chain("client.repos.stats.commit_activity").and_return([nil])
        expect(@subject.repo_commits('foo')).to eq(0)
      end
    end
  end

  describe "#total_commits" do
    it "returns the sum of commits for all public repositories for the given user" do
      @analytics = GithubAnalytics.new(user: 'foo')
      allow(@analytics).to receive(:load_repos).and_return([{name: 'foo_repo'}, {name: 'foo_repo2'}])
      allow(@analytics).to receive(:repo_commits).and_return(10)
      expect(@analytics.total_commits).to eq(20)
    end
  end
end