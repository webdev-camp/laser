require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "does not validate blank" do
    expect(helper.tag_validation("")).to include("empty")
  end
  it "does not validate nil" do
    expect(helper.tag_validation(nil)).to include("empty")
  end
  it "does not validate tag with spaces" do
    expect(helper.tag_validation("not valid")).to include("spaces")
  end
  it "does not validate tag with just one char" do
    expect(helper.tag_validation("1")).to include("longer")
  end
  it "validates string without spaces" do
    expect(helper.tag_validation("ok_tag")).to be nil
  end

end
