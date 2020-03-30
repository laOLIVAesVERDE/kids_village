require 'rails_helper'

RSpec.describe 'kid access control spec', type: :system do
  let(:user) {
    create(:user,
           name: 's2000',
           email: 's2000@example.com',
           password: '12242339',
           password_confirmation: '12242339',
           admin: true)
  }

  let(:facility) {
    create(:facility,
           name: 'Kids Duo',
           user_id: user.id)
  }

  let(:kid_params_for_create) {
    {name: '手巣戸 要介',
     school: '山葉小学校',
     email: 'test@kidsvillage.com',
     introduction: 'こんにちは。'}
  }

  let(:other_user) {
    create(:user,
           name: 'vamos',
           email: 'vamos@example.com',
           password: '12242339',
           password_confirmation: '12242339')
  }

  let(:other_facility) {
    create(:facility,
           name: 'はなまる',
           user_id: other_user.id)
  }

  let(:other_kid) {
    create(:kid,
           name: '本田　花子',
           school: '第一小学校',
           email: 'honda_hanako@kidsvillage.com',
           introduction: 'こんにちは！',
           facility_id: other_facility.id)
  }


  context 'when user does not login' do
    let(:kid) {
      create(:kid,
             name: '本田　太郎',
             school: '第一小学校',
             email: 'honda_taro@kidsvillage.com',
             introduction: 'こんにちは！',
             facility_id: facility.id)
    }

    it 'cannot see his own kids index' do
      visit facility_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot see kid detail' do
      visit facility_kid_path(facility, kid)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot create kid' do
      visit new_facility_kid_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot edit kid info' do
      visit edit_facility_kid_path(facility, kid)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end
  end


  context 'when user login and create first facility' do

    before do
      log_in_as(user)
      visit facility_path(facility)
    end

    it 'cannot create kid without invalid input' do
      click_link '新たに児童を追加する'
      fill_in 'お名前', with: ' '
      fill_in '学校', with: ' '
      fill_in 'メールアドレス', with: ' '
      fill_in '自己紹介', with: ' '
      click_button '児童を追加する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can create kid with valid input' do
      click_link '新たに児童を追加する'
      fill_in 'お名前', with: kid_params_for_create[:name]
      fill_in '学校', with: kid_params_for_create[:school]
      fill_in 'メールアドレス', with: kid_params_for_create[:email]
      fill_in '自己紹介', with: kid_params_for_create[:introduction]
      click_button '児童を追加する'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(kid_params_for_create[:name])
    end

    it 'cannot see other kid detail' do
      visit facility_kid_path(other_facility, other_kid)
      expect(page).to have_title('ホーム')
    end

    it 'cannot edit other kid' do
      visit edit_facility_kid_path(other_facility, other_kid)
      expect(page).to have_title('ホーム')
    end

  end

  context 'when user creates first kid on his/her facility' do
    let(:kid_name) {
      '手巣戸 要介'
    }

    before do
      log_in_as(user)
      visit facility_path(facility)
      click_link '新たに児童を追加する'
      fill_in 'お名前', with: kid_name
      fill_in '学校', with: kid_params_for_create[:school]
      fill_in 'メールアドレス', with: kid_params_for_create[:email]
      fill_in '自己紹介', with: kid_params_for_create[:introduction]
      click_button '児童を追加する'
    end

    it 'can see kid detail' do
      click_link kid_name
      expect(page).to have_title full_title(kid_name)
    end

    it 'cannot edit with invalid input' do
      click_link '編集する'
      fill_in 'お名前', with: ' '
      fill_in '学校', with: ' '
      fill_in 'メールアドレス', with: ' '
      fill_in '自己紹介', with: ' '
      click_button '保存する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can edit kid with valid input' do
      click_link '編集する'
      edit_name = '山葉 太郎'
      fill_in 'お名前', with: edit_name
      fill_in '学校', with: '山葉小学校'
      fill_in 'メールアドレス', with: 'revsyourheart@kidsvillage.com'
      fill_in '自己紹介', with: 'こんにちは。'
      click_button '保存する'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(edit_name)
    end

    it 'can destroy kid' do
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'div.alert-success'
      expect(facility.kids.count).to eq 0
    end
  end


end
