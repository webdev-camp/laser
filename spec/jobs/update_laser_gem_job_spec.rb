require 'rails_helper'

RSpec.describe UpdateLaserGemJob, type: :job do

  it "perform later enques a job" do
    expect {
      UpdateLaserGemJob.perform_later("rails")
    }.to have_enqueued_job.with("rails")

  end
end
