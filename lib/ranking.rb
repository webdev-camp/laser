class Ranking
  COMMIT_ACTIVITY_BANDS = [1.week.ago, 3.months.ago, 6.months.ago, 1.year.ago]
  RECENT_ACTIVITY_BANDS = [1.week.ago, 1.month.ago, 3.months.ago, 6.months.ago]
  FORKS_BANDS = [5000, 500, 50, 1]
  STARGAZERS_BANDS = [5000, 500, 50, 5]
  WATCHERS_BANDS = [1000, 100, 10, 1]

  def initialize(laser_gem)
    @laser_gem = laser_gem
    @gem_git = GemGit.find_by(laser_gem_id: @laser_gem.id)
  end

  def commit_activity_score
    return 0 unless @gem_git
    score_calculation(@gem_git.commit_dates.first, COMMIT_ACTIVITY_BANDS)
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
      return 5
    elsif criterion > score_array[1]
      return 4
    elsif criterion > score_array[2]
      return 3
    elsif criterion > score_array[3]
      return 2
    else
      return 1
    end
  end
end
