class UpdateAllGemsJob < ApplicationJob

  def perform
    LaserGem.all.each do
      UpdateLaserGemJob.perform_later(gem_name)
    end
  end
end
