require "ranking"

class GitLoader

  def initialize()
    @client = Octokit::Client.new :login => ENV["GIT_USER"], :password => ENV["GIT_PASS"]
  end

  def get_from_git repo_name
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
    nil
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
    assignees.collect { |user| [user[:login], user[:id]]}
  end

  # try source_code_uri first, then homepage (must have the github.com in it)
  def parse_git_uri(laser_gem)
    code_uri = laser_gem.gem_spec.source_code_uri
    if code_uri
      matches = matcher(code_uri)
      return matches[1] if matches
    end
    parse_additional_uris(laser_gem)
  end

  def parse_additional_uris(laser_gem)
    candidates = github_repo_name_candidates(laser_gem)
    candidates.find do |c|
      get_git_from_api(c)
    end
  end

  def github_repo_name_candidates(laser_gem)
    return [] unless laser_gem.gem_spec
    candidates = [:homepage_uri, :documentation_uri, :bug_tracker_uri]
    candidates.map do |cand|
      uri = laser_gem.gem_spec[cand]
      matches = matcher(uri)
      matches[1] if matches
    end.select { |c| c != nil }
  end

  def fetch_commit_activity_year(laser_gem)
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    array = get_commit_activity_year(repo_name)
    return nil unless array
    # Extracts [commits in week], oldest -> newest
    commit_dates_year = array.collect { |week| week[:total] }
    return unless git = laser_gem.gem_git
    git.reload
    git.update(commit_dates_year: commit_dates_year)
  end

  def update_owners(laser_gem , repo_name)
    assignee_array = get_owners_from_github(repo_name)
    return unless assignee_array
    assignee_array.each do |git_handle , git_id|
      Ownership.find_or_create_by!(laser_gem_id: laser_gem.id, git_handle: git_handle, github_id: git_id)
    end
  end

  def update_or_create_git(laser_gem)
    return nil unless (laser_gem and  laser_gem.gem_spec)
    repo_name = parse_git_uri(laser_gem)
    return nil unless repo_name
    git_data = get_git_from_api(repo_name)
    return unless git_data
    do_update(laser_gem , git_data)
    update_owners(laser_gem , repo_name)
    laser_gem.gem_git.reload
    fetch_commit_activity_year(laser_gem)
  end

  private

  def do_update(laser_gem , git_data)
    attribs = {}
    git_attributes.each {|laser,git| attribs[laser] = git_data[git] }
    if git = laser_gem.gem_git
      git.update(attribs)
    else
      laser_gem.create_gem_git!(attribs.merge laser_gem_id: laser_gem.id)
    end
  end

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
