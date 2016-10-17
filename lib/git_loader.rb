class GitLoader

  def initialize(client = Octokit::Client.new)
    @client = client
  end

  def get_git_by_name(repo_name)
    @data = @client.repo(repo_name)
  end

  def populate_data(laser_gem)
    github = laser_gem.gem_spec.source_code_uri
    if github.include?('github.com/')
      repo_name = github.split('github.com/')[1]
      @git_data = get_git_by_name(repo_name)
      attribs = {}
      git_attributes.each do |k,v|
        attribs[k] = @git_data[v]
      end
      GemGit.create!(attribs.merge laser_gem_id: laser_gem.id)
    end
  end

  def git_attributes
  {
    name: "name",
    homepage: "homepage",
    last_commit: "pushed_at",
    forks_count: "forks_count",
    stargazers_count: "stargazers_count",
    watchers_count: "watchers_count",
    open_issues_count: "open_issues_count",
  }
  end
end
