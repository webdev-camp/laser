RSpec.describe Ranking do
  describe "#activity_score" do
    it "ranks activity score 1 if latest commit was over a year ago" do
      laser_gem = LaserGem.create(name: "letmein")
      create :gem_git, 
        commit_dates: [2.years.ago], 
        laser_gem: laser_gem
      expect(Ranking.activity_score(laser_gem)).to be 1
    end
  end
end
