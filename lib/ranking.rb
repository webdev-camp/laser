##### TO DO change watchers_count to subscribers_count because the API returns stargazers as watchers.
# should it return an array of the scores and various as an array?
# can i order all gems by no downloads or etc without loading them all or doing loads of requests? 
# how many ranking fields should I add to the lasergem model?
# total rank
# spec rank - as number or percent?
# git rank
# ADD One YEAR activity data
# add fields to model
# add method to add all of above to existin gems
#
class Ranking
  # Scoring bands from 5(max) to 1 for each criterion
  # [a, b, c, d] where criterion > a scores 5, >b scores 4,
  # >c scores 3, >d scores 2, <d scores 1.
  CURRENT_DOWNLOADS_BANDS = [500000, 50000, 25000, 5000] 
  TOTAL_DOWNLOADS_BANDS = [10000000, 5000000, 3000000, 1000000] 
  COMMIT_ACTIVITY_BANDS = [1.week.ago, 3.months.ago, 6.months.ago, 1.year.ago]
  RECENT_ACTIVITY_BANDS = [1.week.ago, 1.month.ago, 3.months.ago, 6.months.ago]
  FORKS_BANDS = [5000, 500, 50, 1]
  STARGAZERS_BANDS = [5000, 500, 50, 5]
  WATCHERS_BANDS = [1000, 100, 10, 1]
  # Importance of each criterion (max 5)
  TOTAL_DOWNLOADS_WEIGHT = 5.0
  CURRENT_DOWNLOADS_WEIGHT = 5.0
  COMMIT_ACTIVITY_WEIGHT = 5.0
  RECENT_ACTIVITY_WEIGHT = 5.0
  FORKS_WEIGHT = 3.0
  STARGAZERS_WEIGHT = 1.0
  WATCHERS_WEIGHT = 0.0

  MAX_SCORE = 5.0
  MAX_WEIGHT = 5.0
  
  def initialize(laser_gem)
    @laser_gem = laser_gem
    @gem_git = GemGit.find_by(laser_gem_id: @laser_gem.id)
    @gem_spec = GemSpec.find_by(laser_gem_id: @laser_gem.id)

  end

  # def rank(laser_gem)
  #   [ [commit_activity_score, COMMIT_ACTIVITY_WEIGHT],
  #     [recent_activity_score, RECENT_ACTIVITY_WEIGHT],
  #     [forks_score, FORKS_WEIGHT],
  #     [stargazers_score, STARGAZERS_WEIGHT],
  #     [watchers_score, WATCHERS_WEIGHT],
  #   ].reduce(0) do |acc, score_weight_pair|
  #     acc + points(*score_weight_pair)
  #   end
  # end

  def total_rank(laser_gem)
    if GemGit.where(laser_gem_id: laser_gem.id).any?
      (spec_rank(laser_gem) + git_rank(laser_gem))/2.0
    else
      spec_rank(laser_gem)
    end
  end

  def spec_rank(laser_gem)
    score_weight_array = [ 
      [total_downloads_score, TOTAL_DOWNLOADS_WEIGHT],
      [current_downloads_score, CURRENT_DOWNLOADS_WEIGHT],
    ]
    sum = score_weight_array.reduce(0) do |acc, score_weight_pair|
      acc + points(*score_weight_pair)
    end
    sum/score_weight_array.count
  end

  def git_rank(laser_gem)
    score_weight_array = [ 
      [commit_activity_score, COMMIT_ACTIVITY_WEIGHT],
      [recent_activity_score, RECENT_ACTIVITY_WEIGHT],
      [forks_score, FORKS_WEIGHT],
      [stargazers_score, STARGAZERS_WEIGHT],
      [watchers_score, WATCHERS_WEIGHT],
    ]
    sum = score_weight_array.reduce(0) do |acc, score_weight_pair|
      acc + points(*score_weight_pair)
    end
    sum/score_weight_array.count
  end

  def points(score, weight)
    (score * weight)/(MAX_SCORE * MAX_WEIGHT)
  end

  def download_rank
    t = GemSpec.all.count
    n = @laser_gem.gem_spec.total_downloads
    download_array = GemSpec.all.pluck(:total_downloads).sort.reverse
    i = (download_array.index(n) + 1).ordinalize
    "#{i} most downloaded gem of #{t} gems"
  end

  def total_downloads_score
    return 0 unless @gem_spec
    score_calculation(@gem_spec.total_downloads, TOTAL_DOWNLOADS_BANDS)
  end
  
  def current_downloads_score
    return 0 unless @gem_spec
    score_calculation(@gem_spec.current_version_downloads, CURRENT_DOWNLOADS_BANDS)
  end

  def commit_activity_score
    return 0 unless @gem_git
    score_calculation(@gem_git.commit_dates_month.first, COMMIT_ACTIVITY_BANDS)
  end

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
