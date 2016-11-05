module Ranking

  def self.activity_score(laser_gem)
    gem_git = GemGit.find_by(laser_gem_id: laser_gem.id)
    if gem_git
      commit_activity(laser_gem, gem_git.commit_dates.last)
    end
  end

  private

  def self.commit_activity(laser_gem, commit_date)
    if commit_date > 1.week.ago
      return 5
    elsif commit_date > 1.month.ago
      return 4
    elsif commit_date > 6.months.ago
      return 3
    elsif commit_date > 1.year.ago
      return 2
    elsif commit_date < 1.year.ago
      return 1
    end
  end
end
