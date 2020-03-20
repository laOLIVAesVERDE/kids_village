require 'rails_helper'

RSpec.describe 'users edit', type: :system do
  include ApplicationHelper

  let(:user) {
    create(:user,
           name: 's2000',
           email: 's2000@example.com',
           password: '12242339',
           password_confirmation: '12242339',
           admin: true)
  }

  let(:other_user) {
    create(:user,
           name: 'vamos',
           email: 'vamos@example.com',
           password: '12242339',
           password_confirmation: '12242339')
  }

  context 'when edit the profile' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit edit_user_path(user)
    end

    it 'cannot be completed with invalid attributes' do
      fill_in 'お名前', with: ' '
      fill_in 'メールアドレス', with: ' '
      fill_in 'パスワード', with: ' '
      fill_in 'パスワード（確認）', with: ' '
      click_button '保存する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can be completed with valid attributes' do
      fill_in 'お名前', with: 'civic'
      fill_in 'メールアドレス', with: 'civic@example.com'
      fill_in 'パスワード', with: '12242339'
      fill_in 'パスワード（確認）', with: '12242339'
      click_button '保存する'
      expect(page).to have_selector 'div.alert-success'
      user.reload
      expect(user.name).to eq 'civic'
      expect(user.email).to eq 'civic@example.com'
    end
  end

  context 'when user does not login' do

      it 'cannot access to user profile' do
        visit user_path(user)
        expect(page).to have_selector 'div.alert-danger'
        expect(page).to have_content 'ログイン'
      end

      it 'cannot access to user edit' do
        visit edit_user_path(user)
        expect(page).to have_selector 'div.alert-danger'
        expect(page).to have_content 'ログイン'
      end

      it 'rendering user edit after login' do
        visit edit_user_path(user)
        expect(page).to have_selector 'div.alert-danger'
        expect(page).to have_content 'ログイン'
        log_in_as(user)
        expect(page).to have_title full_title('Edit user')
      end
  end

  context 'when it is wrong user' do

    before do
      log_in_as(other_user)
    end

    it 'cannot access to user edit' do
      visit user_path(user)
      expect(page).to have_title 'ホーム'
    end
  end

  context 'when user try to delete himiself' do
    it 'cannot be completed without login' do
      visit user_path(user)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'can be completed after login' do
      log_in_as(user)
      visit edit_user_path(user)
      expect(page).to have_title full_title('Edit user')
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_title full_title 'ホーム'
    end
  end

end
