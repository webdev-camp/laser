require 'rails_helper'

RSpec.describe UpdateAllGemsJob, type: :job do

  it "enqueues one job per gem job" do
    laser = create :laser_gem
    UpdateAllGemsJob.perform_now
    expect(UpdateLaserGemJob).to have_been_enqueued.with(laser.name)
  end

end
