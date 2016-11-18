RSpec.describe LaserGemsHelper, type: :helper do
  describe "number with k" do
    it "adds M for number larger than 1000*1000" do
      expect(helper.k_numbers(84720000)).to eq("84M")
    end
    it "adds k for number larger than 1000" do
      expect(helper.k_numbers(847200)).to eq("847k")
    end
    it "shows number smaller than 1000" do
      expect(helper.k_numbers(847)).to eq("847")
    end
  end

  describe "tags_cloud" do
    it "adds the most popular five tags" do
      expect(helper.tags_cloud).to eq(ActsAsTaggableOn::Tag.most_used(5))
    end
  end

  describe "laser_gems_cloud" do
    it "adds the most popular ten laser gems" do
      expect(helper.laser_gems_cloud).to eq(LaserGem.all.includes(:gem_spec).limit(10))
    end
  end
end
