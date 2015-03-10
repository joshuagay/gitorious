class LoginPage
  include Page

  def login(user = USER, password = PASS)
    visit '/login'
    fill_in 'email', with: user
    fill_in 'password', with: password
    click_button 'Log in'
  end
end

def login_page
  LoginPage.new
end
