
RSpec.describe GemGit, type: :model do
  it "has working factory" do
    gem_git = build :gem_git
    expect(gem_git.save).to be true
  end

  it "checks name attribute" do
    gem_git = build :gem_git, name: ""
    expect(gem_git.save).to be false
  end

  it "checks homepage attribute" do
    gem_git = build :gem_git, homepage: ""
    expect(gem_git.save).to be false
  end

  it "checks last_commit attribute" do
    gem_git = build :gem_git, last_commit: nil
    expect(gem_git.save).to be false
  end

  it "checks forks_count attribute" do
    gem_git = build :gem_git, forks_count: nil
    expect(gem_git.save).to be false
  end

  it "checks stargazers_count attribute" do
    gem_git = build :gem_git, stargazers_count: nil
    expect(gem_git.save).to be false
  end

  it "checks watchers_count attribute" do
    gem_git = build :gem_git, watchers_count: nil
    expect(gem_git.save).to be false
  end

  it "checks open_issues_count attribute" do
    gem_git = build :gem_git, open_issues_count: nil
    expect(gem_git.save).to be false
  end
end
