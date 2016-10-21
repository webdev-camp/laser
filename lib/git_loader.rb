class GitLoader

  def initialize(client = Octokit::Client.new)
    @client = client
  end

  def get_git_from_api(repo_name)
    @data = @client.repo(repo_name)
  end

  def parse_git_uri(laser_gem)
    if laser_gem.gem_spec
      if laser_gem.gem_spec.source_code_uri != nil
        uri = laser_gem.gem_spec.source_code_uri
        rex = /.+\/github.com\/([\w-]+\/[\w-]+)/
        matches = rex.match(uri)
        if !!(rex.match uri)
          @repo_name = matches[1]
        end
      end
    end
  end

  def fetch_and_create_gem_git(laser_gem)
    parse_git_uri(laser_gem)
    if @repo_name
      @git_data = get_git_from_api(@repo_name)
      attribs = {}
      git_attributes.each do |k,v|
        attribs[k] = @git_data[v]
      end
      GemGit.find_or_create_by(attribs.merge laser_gem_id: laser_gem.id) unless laser_gem.gem_git
      fetch_git_for_deps(laser_gem)
      # Need an else here to return an error to user/uploader
    end
  end

  def fetch_git_for_deps(laser_gem)
    laser_gem.dependencies.map(&:name).each do |dep|
      lg_dep = LaserGem.find_by(name: dep)
      if lg_dep
        fetch_and_create_gem_git(lg_dep)  if lg_dep.gem_git.nil?
      end
    end
  end

  def git_attributes
    {
      name: "full_name",
      homepage: "homepage",
      last_commit: "pushed_at",
      forks_count: "forks_count",
      stargazers_count: "stargazers_count",
      watchers_count: "watchers_count",
      open_issues_count: "open_issues_count",
    }
  end
end
