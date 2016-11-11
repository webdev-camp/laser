module LoginHelper

  def sign_in_user is_admin = false
    user = create(:user , admin: is_admin)
    visit new_user_session_path
    fill_in "Email" , with: user.email
    fill_in "Password" , with: user.password
    click_button "Log in"
    user
  end

  def sign_in_admin
    sign_in_user( true )
  end

  def sign_in_owner
    sign_in_user( true )
  end

  def log_out_user
    visit destroy_user_session_path
    click_button "Log out"
  end
end
