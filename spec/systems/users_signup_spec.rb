require 'rails_helper'

RSpec.describe 'users signup', type: :system do
  include ApplicationHelper, SessionsHelper

  before { visit signup_path }

  it 'cannot complete with invalid attributes' do
    expect {
      fill_in "お名前", with: " "
      fill_in "メールアドレス", with: " "
      attach_file "プロフィール画像", "#{Rails.root}/app/assets/images/default.jpg"
      fill_in "パスワード", with: " "
      fill_in "パスワード（確認）", with: " "
      click_button "Kids Villageへようこそ"
    }.not_to change(User, :count)

    expect(page).to have_selector 'div.field_with_errors'
    expect(page).to have_selector 'div#error_explanation'
    expect(page).to have_selector 'form[action="/signup"'
  end

  it 'can complete with valid attributes' do
    user = FactoryBot.build(
      :user,
        name: "integra",
        email: "integra@example.com",
        password: '12242339',
        password_confirmation: '12242339',
      )
    expect {
      fill_in "お名前", with: user.name
      fill_in "メールアドレス", with: user.email
      attach_file "プロフィール画像", "#{Rails.root}/app/assets/images/default.jpg"
      fill_in "パスワード", with: user.password
      fill_in "パスワード（確認）", with: user.password_confirmation
      click_button "Kids Villageへようこそ"
    }.to change(User, :count).to(1)
    expect(page).to have_title full_title(user.name)
    expect(page).to have_selector 'div.alert-success'
    click_link 'アカウント'
    expect(page).to have_link 'ログアウト', href: logout_path
  end


end
