RSpec.describe LaserGem, type: :model do

  it "has working factory with ownerships ,users, gem_gits, gem_specs"
  it "owner is indexed to user"
  it "allows owner to be used as a method"
  it "ownership has correct owners for each laser_gem"
  it "ownership has role 'owner' for each ownership"
  it "ownership has unique gem_spec_id for each laser_gem_id"
  it "ownership has unique gem_git_id for each laser_gem_id"
  it "LaserGem_id and gem_spec and gem_git id for each ownership are correct"
end
