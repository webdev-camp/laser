class GitLoader

  def initialize(client = Octokit::Client.new)
    @client = client
  end

  def get_git_from_api(repo_name)
    @data = @client.repo(repo_name)
  end

  def fetch_and_create_gem_git(laser_gem)
    if laser_gem.gem_spec
      github = laser_gem.gem_spec.source_code_uri
      if github.include?('github.com/')
        repo_name = github.split('github.com/').last
        @git_data = get_git_from_api(repo_name)
        attribs = {}
        git_attributes.each do |k,v|
          attribs[k] = @git_data[v]
        # Need an else here to return an error to user/uploader
        end
        GemGit.find_or_create_by!(attribs.merge laser_gem_id: laser_gem.id) unless laser_gem.gem_git
      end
      fetch_git_for_deps(laser_gem)
    # Need an else here - either to call GemLoader or to return an error
    end
  end

  def fetch_git_for_deps(laser_gem)
    laser_gem.dependencies.map(&:name).each do |dep|
      lg_dep = LaserGem.find_or_create_by!(name: dep)
      laser_gem.register_dependency(lg_dep, ver) unless GemDependency.where("laser_gem_id = ? and dependency_id = ?", laser_gem.id, lg_dep.id).exists?
      fetch_and_create_gem_git(lg_dep)  if lg_dep.gem_git.nil?
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
