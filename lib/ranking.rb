##### TO DO change watchers_count to subscribers_count because the API returns stargazers as watchers.
class Ranking
  # Scoring bands from 5(max) to 1 for each criterion
  # [a, b, c, d] where criterion > a scores 5, >b scores 4,
  # >c scores 3, >d scores 2, <d scores 1.
  TOTAL_DOWNLOADS_BANDS = [10000000, 5000000, 3000000, 1000000] 
  CURRENT_DOWNLOADS_BANDS = [500000, 50000, 25000, 5000] 
  DEPENDENT_GEMS_BANDS = [8000, 800, 80, 8]
  COMMIT_ACTIVITY_BANDS = [5, 3, 1, 0.5]
  RECENT_ACTIVITY_BANDS = [1.week.ago, 1.month.ago, 3.months.ago, 6.months.ago]
  FORKS_BANDS = [5000, 500, 50, 1]
  STARGAZERS_BANDS = [5000, 500, 50, 5]
  WATCHERS_BANDS = [1000, 100, 10, 1]
  # Importance of each criterion (max 5)
  DEPENDENT_GEMS_WEIGHT = 5.0
  TOTAL_DOWNLOADS_WEIGHT = 5.0
  CURRENT_DOWNLOADS_WEIGHT = 5.0
  COMMIT_ACTIVITY_WEIGHT = 5.0
  RECENT_ACTIVITY_WEIGHT = 5.0
  FORKS_WEIGHT = 3.0
  STARGAZERS_WEIGHT = 1.0
  WATCHERS_WEIGHT = 0.0

  MAX_SCORE = 5.0
  MAX_SPEC_WEIGHT_TOTAL = [DEPENDENT_GEMS_WEIGHT, TOTAL_DOWNLOADS_WEIGHT, CURRENT_DOWNLOADS_WEIGHT].sum
  MAX_GIT_WEIGHT_TOTAL = [COMMIT_ACTIVITY_WEIGHT, RECENT_ACTIVITY_WEIGHT, FORKS_WEIGHT, STARGAZERS_WEIGHT, WATCHERS_WEIGHT].sum
  
  def initialize(laser_gem)
    @laser_gem = laser_gem
    @gem_git = GemGit.find_by(laser_gem_id: @laser_gem.id)
    @gem_spec = GemSpec.find_by(laser_gem_id: @laser_gem.id)

  end

  def total_rank_position
    _t = LaserGem.all.count
    n = @laser_gem.total_rank
    #TODO make sure to change htis to remove nil from rank_array because cannot sort otherwise - float cannot be compared to nil
    rank_array = LaserGem.all.pluck(:total_rank).sort.reverse
    (rank_array.index(n) + 1)
  end

  def total_rank_calc
    if @laser_gem.gem_git
      rank_total = spec_rank + git_rank
      max_rank_total = max_git_rank_total + max_spec_rank_total
      total_rank = rank_total/max_rank_total
    else
      total_rank = spec_rank/max_spec_rank_total
    end
    @laser_gem.update(total_rank: total_rank)
    total_rank
  end

  def spec_rank
    score_weight_array = [ 
      [dependent_gems_score, DEPENDENT_GEMS_WEIGHT],
      [total_downloads_score, TOTAL_DOWNLOADS_WEIGHT],
      [current_downloads_score, CURRENT_DOWNLOADS_WEIGHT],
    ]
    sum = score_weight_array.reduce(0) do |acc, score_weight_pair|
      acc + rank(*score_weight_pair)
    end
    sum
  end

  def git_rank
    score_weight_array = [ 
      [commit_activity_score, COMMIT_ACTIVITY_WEIGHT],
      [recent_activity_score, RECENT_ACTIVITY_WEIGHT],
      [forks_score, FORKS_WEIGHT],
      [stargazers_score, STARGAZERS_WEIGHT],
      [watchers_score, WATCHERS_WEIGHT],
    ]
    sum = score_weight_array.reduce(0) do |acc, score_weight_pair|
      acc + rank(*score_weight_pair)
    end
    sum
  end

  def max_git_rank_total
    MAX_SCORE * MAX_GIT_WEIGHT_TOTAL
  end

  def max_spec_rank_total
    MAX_SCORE * MAX_SPEC_WEIGHT_TOTAL
  end

  def rank(score, weight)
    score * weight
  end

  def download_rank_string_calc
    t = GemSpec.all.count
    n = @laser_gem.gem_spec.total_downloads
    download_array = GemSpec.all.pluck(:total_downloads).sort.reverse
    i = (download_array.index(n) + 1).ordinalize
    download_rank_string = "#{i} most downloaded gem of #{t} gems"
    @laser_gem.update(download_rank_string: download_rank_string)
    @laser_gem.save
    download_rank_string
  end

  def download_rank_percent_calc
    t = GemSpec.all.count
    n = @laser_gem.gem_spec.total_downloads
    download_array = GemSpec.all.pluck(:total_downloads).sort.reverse
    i = (download_array.index(n) + 1)
    download_rank_percent = i/(t*1.0)
    @laser_gem.update(download_rank_percent: download_rank_percent)
    @laser_gem.save
    download_rank_percent
  end

  def dependent_gems_score
    return 0 unless @gem_spec
    score_calculation(@laser_gem.dependents.count, DEPENDENT_GEMS_BANDS)
  end

  def total_downloads_score
    return 0 unless @gem_spec
    score_calculation(@gem_spec.total_downloads, TOTAL_DOWNLOADS_BANDS)
  end
  
  def current_downloads_score
    return 0 unless @gem_spec
    score_calculation(@gem_spec.current_version_downloads, CURRENT_DOWNLOADS_BANDS)
  end

  # This is the number of commits per week averaged over a year
  def commit_activity_score
    return 0 unless @gem_git
    commits_sum = @gem_git.commit_dates_year.reduce(0.0) do |acc, week| 
      acc + week
    end
    commits_average = commits_sum / @gem_git.commit_dates_year.length
    score_calculation(commits_average, COMMIT_ACTIVITY_BANDS)
  end

  # This is simply date of latest commit but doesnt represent standard commit activity ie it could be recent even for a gem that is rarely updated
  def recent_activity_score
    return 0 unless @gem_git
    score_calculation(@gem_git.last_commit, RECENT_ACTIVITY_BANDS)
  end

  def forks_score
    return 0 unless @gem_git
    score_calculation(@gem_git.forks_count, FORKS_BANDS)
  end

  def stargazers_score
    return 0 unless @gem_git
    score_calculation(@gem_git.stargazers_count, STARGAZERS_BANDS)
  end

  def watchers_score
    return 0 unless @gem_git
    score_calculation(@gem_git.watchers_count, WATCHERS_BANDS)
  end

  private

  def score_calculation(criterion, score_array)
    if criterion > score_array[0]
      return 5.0
    elsif criterion > score_array[1]
      return 4.0
    elsif criterion > score_array[2]
      return 3.0
    elsif criterion > score_array[3]
      return 2.0
    else
      return 1.0
    end
  end
end
