RSpec.describe LaserGemsHelper, type: :helper do
  describe "number with k" do
    it "adds k for number larger than 1000" do
      expect(helper.k_numbers(847200)).to eq("847k")
    end
    it "shows number smaller than 1000" do
      expect(helper.k_numbers(847)).to eq("847")
    end
  end
end
