class GitLoader

  def initialize()
    @client = Octokit::Client.new :login => ENV["GIT_USER"], :password => ENV["GIT_PASS"]
  end

  def get_from_git
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
    get_from_git { @client.repo(repo_name) }
  end

  def get_commits_from_api(repo_name)
    get_from_git { @client.commits(repo_name) }
  end

  def get_commit_activity_year(repo_name)
    get_from_git { @client.commit_activity_stats(repo_name) }
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
      Ownership.where(["gem_handle = ? and laser_gem_id = ?", git_handle, laser_gem.id]).update_all(git_handle: git_handle, github_profile: github_profile, github_owner: true)
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
      # look at homepage anyway if source_code_uri was not a github
    end
    parse_homepage_uri(laser_gem)
  end

  def parse_homepage_uri(laser_gem)
    # Extract the github repo name ot of the homepage_uri
    return nil unless laser_gem.gem_spec[:homepage_uri]
    uri = laser_gem.gem_spec[:homepage_uri]
    matches = matcher(uri)
    return matches[1] if matches
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

  def fetch_commits_for_git(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    array = get_commits_from_api(repo_name)
    return nil unless array
    array_commit_dates = array.collect do |date|
      date[:commit][:author][:date]
    end
    sorted_commit_dates = array_commit_dates.sort
    if GemGit.where(laser_gem_id: laser_gem.id)
      GemGit.where(laser_gem_id: laser_gem.id).update_all(commit_dates_month: sorted_commit_dates)
      sorted_commit_dates
    end
  end

  # helper to add latest 30 commits to db for each gem.
  def fetch_commits_for_all
    LaserGem.all.each do |laser_gem|
      fetch_commits_for_git(laser_gem)
    end
  end

  # Can serialize and save in db?
  def fetch_commit_activity_year(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    array = get_commit_activity_year(repo_name)
    laser_gem.reload
    return nil unless array
    # Extracts [commits in week] and [week start date], oldest -> newest
    commit_dates_year = array.collect { |week| week[:total] }
    if GemGit.where(laser_gem_id: laser_gem.id)
      GemGit.where(laser_gem_id: laser_gem.id).update_all(commit_dates_year: commit_dates_year)
    end
  end

  private

  # match the uri to see if it contains github.com and return the match_data
  def matcher(uri)
    rex = /.+\/github.com\/([\w-]+\/[\w-]+)/
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
      watchers_count: "watchers_count",
      open_issues_count: "open_issues_count",
    }
  end
end
