class UpdateAllGemsJob < ApplicationJob

  def perform
    LaserGem.all.each do |laser|
      UpdateLaserGemJob.perform_later(laser.name)
    end
  end
end
