Warden.test_mode!

RSpec.describe "UserSessions" do

  after(:each) do
    Warden.test_reset!
  end

  it "allows a user to register" do
    visit new_user_registration_path
    fill_in("Name", with: "alice")
    fill_in("Email", with: "alice@example.com")
    fill_in("Password", with: "password")
    fill_in("Password confirmation", with: "password")
    click_button('Sign up')
    expect(page).to have_current_path(root_path)
    expect(page.status_code).to be 200
  end

  it "does not allow a user to register with invalid name" do
    visit new_user_registration_path
    user = create :user
    fill_in(:'user_name', with: "n")
    fill_in(:'user_email', with: user.email)
    fill_in(:'user_password', with: user.password)
    fill_in(:'user_password_confirmation', with: user.password)
    click_button('Sign up')
    expect(page).to have_current_path('/users')
    expect(page).to have_text("Name is too short")
  end

  it "does not allow a user to register with invalid email" do
    visit new_user_registration_path
    user = create :user
    fill_in(:'user_name', with: user.name)
    fill_in(:'user_email', with: "email")
    fill_in(:'user_password', with: user.password)
    fill_in(:'user_password_confirmation', with: user.password)
    click_button('Sign up')
    expect(page).to have_current_path('/users')
    expect(page).to have_text("Email is invalid")
  end

  xit "sends an email to a user for confirmation"

  it "allows a confirmed user to log in" do
    sign_in_user
    expect(page).to have_text("Log Out")
    expect(page.status_code).to be 200
  end

  it "allows a logged in user to log out" do
    sign_in_user
    click_link("Log Out")
    expect(page).to have_text("Log In")
    expect(page.status_code).to be 200
  end
end
