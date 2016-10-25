class GitLoader

  def initialize(client = Octokit::Client.new)
    @client = client
  end

  def get_git_from_api(repo_name)
    @client.repo(repo_name)
  end

  def get_owners_from_github(repo_name)
    assignees = @client.repo(repo_name).rels[:assignees].get(:query => {:per_page => 100 }).data
    @assignee_names = assignees.collect do |user| 
      _un = user[:login], _up = user[:html_url] 
    end
  end

  def fetch_assignees(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return unless repo_name
    assignee_array = get_owners_from_github(repo_name)
    assignee_array.each do |assig|
      git_handle = assig[0]
      github_profile = assig[1]
      # Joint ownership
      _joint_ownership =  Ownership.where(["gem_handle = ? and laser_gem_id = ?", git_handle, laser_gem.id]).update_all(git_handle: git_handle, github_profile: github_profile, role: "rubygem and github owner", github_owner: true)
      # only github ownership
      ownership = Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, git_handle: git_handle, github_profile: github_profile, github_owner: true)
      ownership.update({ role: "github owner", github_owner: true })
      if laser_gem.gem_spec
        ownership.update({ gem_spec_id: ownership.laser_gem.gem_spec.id })
      end
      if laser_gem.gem_git
        ownership.update({gem_git_id: ownership.laser_gem.gem_git.id })
      end
    end
    fetch_git_owners_for_deps(laser_gem)
  end

  def fetch_git_owners_for_deps(laser_gem)
    laser_gem.dependencies.map(&:name).each do |dep|
      lg_dep = LaserGem.find_by(name: dep)
      if lg_dep
        fetch_assignees(lg_dep) if lg_dep.ownerships.where(github_owner: true).count == 0
      end
    end
  end

  def parse_git_uri(laser_gem)
    return unless laser_gem.gem_spec
    rex = /.+\/github.com\/([\w-]+\/[\w-]+)/
    if laser_gem.gem_spec.source_code_uri != nil
      uri = laser_gem.gem_spec.source_code_uri
      matches = rex.match(uri)
      if !!(rex.match uri)
        return matches[1]
      end
    else
      parse_homepage_uri(laser_gem)
    end
  end

  def parse_homepage_uri(laser_gem)
    # Extract and add homepage uri
    if laser_gem.gem_spec[:homepage_uri] != nil
      uri = laser_gem.gem_spec[:homepage_uri]
      matches = rex.match(uri)
      if !!(rex.match uri)
        return matches[1]
      end
    end
  end

  def fetch_and_create_gem_git(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return unless repo_name
    git_data = get_git_from_api(repo_name)
    attribs = {}
    git_attributes.each do |k,v|
      attribs[k] = git_data[v]
    end
    GemGit.find_or_create_by(attribs.merge laser_gem_id: laser_gem.id) unless laser_gem.gem_git
    fetch_git_for_deps(laser_gem)
    # Need an else here to return an error to user/uploader
    fetch_assignees(laser_gem)
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
