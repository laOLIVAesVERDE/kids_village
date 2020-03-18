module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
