require 'rails_helper'

RSpec.describe UpdateLaserGemJob, type: :job do

  it "perform later enques a job" do
    expect {
      UpdateLaserGemJob.perform_later("rails")
    }.to have_enqueued_job.with("rails")
  end

  it "updates the updated_at" , :vcr do
    gemloader = GemLoader.new
    laser = gemloader.create_or_update_spec("rails")
    laser.update_attributes( updated_at: Time.now - 8.days )
    UpdateLaserGemJob.perform_now("rails")
    laser.reload
    expect(laser.updated_at - Time.now).to be < 1
  end

  it "updates the rank" , :vcr do
    gemloader = GemLoader.new
    laser = gemloader.create_or_update_spec("rails")
    laser.update_attributes( total_rank: 0 )
    UpdateLaserGemJob.perform_now("rails")
    laser.reload
    expect(laser.total_rank).to be > 0.6
  end
end
