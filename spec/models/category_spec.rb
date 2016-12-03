require 'rails_helper'

RSpec.describe Category, type: :model do
  it "has working factory" do
    category = build :category
    expect(category.save).to be true
  end
end
