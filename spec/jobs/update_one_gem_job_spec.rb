require 'rails_helper'

RSpec.describe UpdateOneGemJob, type: :job do

  it "doe not enqueue a job if it has been updated less thana week ago" do
    laser = create :laser_gem
    UpdateOneGemJob.perform_now
    expect(UpdateLaserGemJob).not_to have_been_enqueued.with(laser.name)
  end

  it "enqueues a job when it has been updated over a week ago" do
    laser = create :laser_gem , updated_at: Time.now - 8.days
    UpdateOneGemJob.perform_now
    expect(UpdateLaserGemJob).to have_been_enqueued.with(laser.name)
  end
end
