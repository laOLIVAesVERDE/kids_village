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

  def create_kid(facility, kid_name, kid_school, kid_email, kid_introduction)
    visit facility_path(facility)
    click_link '新たに児童を追加する'
    sleep(2)
    fill_in 'お名前', with: kid_name
    fill_in '学校', with: kid_school
    fill_in 'メールアドレス', with: kid_email
    fill_in '自己紹介', with: kid_introduction
    click_button '児童を追加する'
  end

  def take_screenshot
    page.save_screenshot "screenshot-#{DateTime.now}.png"
  end
end
