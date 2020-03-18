require 'rails_helper'

RSpec.describe 'users login', type: :system do
  include ApplicationHelper, SessionsHelper

  before { visit login_path }

  describe 'cannot complete with invalid POST content' do
    before do
      fill_in "メールアドレス", with: " "
      fill_in "パスワード", with: " "
      click_button "ログイン"
    end

    it 'gets the flash message' do
      expect(page).to have_selector 'div.alert-danger'
    end

    context 'access to other page' do
      before { visit root_path }
      it 'disappers the flash message' do
        expect(page).not_to have_selector 'div.alert-danger'
      end
    end

  end

  describe 'can complete with valid POST content' do
    let(:user) {
      create(:user,
             name: 's2000',
             email: 's2000@example.com',
             password: '12242339',
             password_confirmation: '12242339')
    }

    before do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    context 'on the rendered view' do
      it 'page does not have link to login' do
        expect(page).not_to have_link nil, href: login_path
      end
      it "page has link to profile and logout in the account dropdown" do
        click_link "アカウント"
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_link "ログアウト", href: logout_path
      end
      it 'can be logged out' do
        click_link 'アカウント'
        click_link 'ログアウト'
        expect(page).to have_link 'ログイン', login_path
        expect(page).to have_selector 'div.alert-success'
        expect(page).to_not have_link 'Account'
        expect(page).to_not have_link nil, href: logout_path
        expect(page).to_not have_link nil, href: user_path(user)
      end
    end

  end
end
