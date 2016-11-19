class GitLoader

  def initialize()
    @client = Octokit::Client.new :login => ENV["GIT_USER"], :password => ENV["GIT_PASS"]
  end

  def get_from_git repo_name
    result = nil
    begin
      return yield
    rescue Octokit::NotFound # => not_found
      puts "Not found #{repo_name}"
    rescue Faraday::ConnectionFailed #=> offline
      puts "Not found #{repo_name}"
    rescue StandardError => e
      puts e.message
      puts "Exception #{repo_name}"
    end
    result
  end

  def get_git_from_api(repo_name)
    get_from_git(repo_name) { @client.repo(repo_name) }
  end

  def get_commits_from_api(repo_name)
    get_from_git(repo_name) { @client.commits(repo_name) }
  end

  def get_commit_activity_year(repo_name)
    get_from_git(repo_name) { @client.commit_activity_stats(repo_name) }
  end

  def get_owners_from_github(repo_name)
    repo = get_git_from_api(repo_name)
    return nil unless repo
    assignees = repo.rels[:assignees].get(:query => {:per_page => 100 }).data
    assignees.collect do |user|
      [user[:login], user[:html_url]]
    end
  end

  def fetch_assignees(laser_gem )
    # For future use, check dependencies if returns.
    return unless laser_gem.ownerships.where(github_owner: true).empty?
    repo_name = parse_git_uri(laser_gem)
    return unless repo_name
    assignee_array = get_owners_from_github(repo_name)
    return unless assignee_array
    assignee_array.each do |assig|
      git_handle = assig[0]
      github_profile = assig[1]
      # Joint ownership
      Ownership.where(["gem_handle = ? and laser_gem_id = ?", git_handle, laser_gem.id]).update(git_handle: git_handle, github_profile: github_profile, github_owner: true)
      # only github ownership
      Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, git_handle: git_handle, github_profile: github_profile, github_owner: true)
    end
    fetch_git_owners_for_deps(laser_gem)
  end

  def fetch_git_owners_for_deps(laser_gem)
    laser_gem.dependencies.each do |dep|
      fetch_assignees(dep) if dep.ownerships.where(github_owner: true).empty?
    end
  end

  def parse_git_uri(laser_gem)
    return unless GemSpec.where(laser_gem_id: laser_gem.id).any?
    # try source_code_uri first, then homepage (must have the github.com in it)
    # if GemSpec.where(laser_gem_id: laser_gem.id).source_code_uri != nil
    if laser_gem.gem_spec.source_code_uri != nil
      uri = laser_gem.gem_spec.source_code_uri
      matches = matcher(uri)
      return matches[1] if matches
    end
    parse_additional_uris(laser_gem)
  end

  def parse_additional_uris(laser_gem)
    if laser_gem.gem_spec[:homepage_uri]
      uri = laser_gem.gem_spec[:homepage_uri]
      matches = matcher(uri)
      if matches 
        return matches[1] unless get_git_from_api(matches[1]) == nil
      end
    end
    if laser_gem.gem_spec[:documentation_uri]
      uri = laser_gem.gem_spec[:documentation_uri]
      matches = matcher(uri)
      if matches 
        return matches[1] unless get_git_from_api(matches[1]) == nil
      end
    end
    if laser_gem.gem_spec[:bug_tracker_uri]
      uri = laser_gem.gem_spec[:bug_tracker_uri]
      matches = matcher(uri)
      return matches[1] if matches
    else return nil
    end
  end

  def fetch_and_create_gem_git(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    if repo_name
      git_data = get_git_from_api(repo_name)
      if git_data and not laser_gem.gem_git
        attribs = {}
        git_attributes.each {|k,v| attribs[k] = git_data[v] }
        laser_gem.create_gem_git!(attribs.merge laser_gem_id: laser_gem.id)
        fetch_assignees(laser_gem)
      end
    end
    fetch_git_for_deps(laser_gem)
  end

  def fetch_git_for_deps(laser_gem)
    laser_gem.dependencies.each do |dep|
      fetch_and_create_gem_git(dep) if dep.gem_git.nil?
    end
  end

  def get_commits_from_api(repo_name)
    begin
      return @client.commits(repo_name)
    rescue Octokit::NotFound # => not_found
      puts "Not found #{repo_name}"
    rescue Faraday::ConnectionFailed #=> offline
      puts "Oops, something is offline #{repo_name}"
    rescue Exception => e
      puts e.message
      puts "Exception #{repo_name}"
    end
    return nil
  end

  def get_commit_activity_year(repo_name)
    begin
      # sleep(1)
      return @client.commit_activity_stats(repo_name)
    rescue Octokit::NotFound # => not_found
      puts "Not found #{repo_name}"
    rescue Faraday::ConnectionFailed #=> offline
      puts "Oops something is offline #{repo_name}"
    rescue Exception => e
      puts e.message
      puts "Exception #{repo_name}"
    end
    return nil
  end


  # helper to add year of commits per week to db for each gem.
  def fetch_commits_for_all
    LaserGem.all.each do |laser_gem|
      fetch_commit_activity_year(laser_gem)
    end
  end

  def fetch_commit_activity_year(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    array = get_commit_activity_year(repo_name)
    return nil unless array
    # Extracts [commits in week], oldest -> newest
    commit_dates_year = array.collect { |week| week[:total] }
    if laser_gem.gem_git
      laser_gem.gem_git.reload
      laser_gem.gem_git.update(commit_dates_year: commit_dates_year)
    end
  end

  def update_or_create_git(gem_name)
    laser_gem = LaserGem.find_by(name: gem_name)
    return nil if laser_gem == nil
    return unless laser_gem.gem_spec
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    assignee_array = get_owners_from_github(repo_name)
    return unless assignee_array
    assignee_array.each do |assig|
      git_handle = assig[0]
      github_profile = assig[1]
      # Joint ownership
      Ownership.where(["gem_handle = ? and laser_gem_id = ?", git_handle, laser_gem.id]).update(git_handle: git_handle, github_profile: github_profile, github_owner: true)
      # only github ownership
      Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, git_handle: git_handle, github_profile: github_profile, github_owner: true)
    end
    git_data = get_git_from_api(repo_name)
    if git_data
      attribs = {}
      git_attributes.each {|k,v| attribs[k] = git_data[v] }
      if laser_gem.gem_git
        laser_gem.gem_git.update(attribs.merge laser_gem_id: laser_gem.id)
        laser_gem.gem_git.reload
      else
        laser_gem.create_gem_git!(attribs.merge laser_gem_id: laser_gem.id)
        laser_gem.gem_git.reload
      end
        fetch_commit_activity_year(laser_gem)
    end
  end

  private

  # match the uri to see if it contains github.com and return the match_data
  def matcher(uri)
    rex = /github.com\/([\w-]+\/[\w-]+)/
    return rex.match(uri)
  end

  # attributes that we get from the github api.
  # Hash that maps our attribute names to github attribute names
  def git_attributes
    {
      name: "full_name",
      homepage: "homepage",
      last_commit: "pushed_at",
      forks_count: "forks_count",
      stargazers_count: "stargazers_count",
      watchers_count: "subscribers_count",
      open_issues_count: "open_issues_count",
    }
  end
end
