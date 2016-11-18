module ApplicationHelper


  def rank_to_i laser_gem
    return 0 unless laser_gem.total_rank
    (laser_gem.total_rank * 100).to_i
  end

end
