class UpdateOneGemJob < ApplicationJob

  def perform
    nekst = LaserGem.unscoped.order( updated_at: :asc).limit(1).first
    weeks = (Time.now - nekst.updated_at) / 1.week
    return if weeks < 1
    UpdateLaserGemJob.perform_later( nekst.name )
  end
end
