require 'rails_helper'

RSpec.describe 'facility access control', type: :system do
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



  context 'when user does not login' do
    it "cannot see user's facilities index" do
      visit user_path(user)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it "cannot see user's facilities detail" do
      facility = user.facilities.create(name: 'Kids Duo')
      visit facility_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot create new facility' do
      visit new_facility_path
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot edit facility name' do
      facility = user.facilities.create(name: 'Kids Duo')
      visit edit_facility_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end
  end

  context 'when user login' do
    before do
      log_in_as(user)
      visit user_path(user)
    end

    it 'cannot create facility without name' do
      click_link '新たに施設を追加する'
      facility_name = ' '
      fill_in '施設名', with: facility_name
      click_button '施設を追加する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can create facility with name' do
      click_link '新たに施設を追加する'
      facility_name = 'Motore'
      fill_in '施設名', with: facility_name
      click_button '施設を追加する'
      expect(page).to have_content facility_name
    end

    it "cannot see other user's facility detail" do
      facility = other_user.facilities.create(name: 'はなまる')
      visit facility_path(facility)
      expect(page).to have_title 'ホーム'
    end

    it "cannot edit other user's facility" do
      facility = other_user.facilities.create(name: 'はなまる')
      visit edit_facility_path(facility)
      expect(page).to have_title 'ホーム'
    end

  end

  context 'after user create first facility' do
    let :facility_name do
      'Motore'
    end

    before do
      log_in_as(user)
      visit user_path(user)
      click_link '新たに施設を追加する'
      fill_in '施設名', with: facility_name
      click_button '施設を追加する'
    end

    it 'can see facility detail' do
      click_link facility_name
      expect(page).to have_title full_title(facility_name)
    end

    it 'cannot edit facility without name' do
      click_link '編集する'
      fill_in '施設名', with: ' '
      click_button '保存する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can edit facility with name' do
      click_link '編集する'
      fill_in '施設名', with: 'Sakura'
      click_button '保存する'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_link 'Sakura'
    end

    it 'can destroy facility' do
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'div.alert-success'
      expect(user.facilities.count).to eq 0
    end


  end

end
