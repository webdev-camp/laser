class Ranking
  # i dont need a class unless i need class.new...
  # i do also need to put the data i need in the db first and then i need a method worker that gets the data if it isnt there if there is sufficient info in hte db to make that calc, then get it. Butthat isnt ideal.
  # should sep getting data, and analysis or transforming of data
  # at teh very end i could even have top level class that says run the fetcher then run hte analyser.

  def initialize()
  end

  def activity_score(laser_gem)
    if laser_gem.gem_git
      # most recent commit (of array of 30)
      commit_activity(laser_gem, laser_gem.gem_spec.commit_date[-1])
    end
  end

  def commit_activity(laser_gem, commit_date)
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
