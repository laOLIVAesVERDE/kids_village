require 'rails_helper'

RSpec.describe 'for kid access control', type: :system do
  let(:user) {
    create(:user,
           name: 's2000',
           email: 's2000@example.com',
           password: '12242339',
           password_confirmation: '12242339',
           admin: true)
  }

  let(:facility_name) {
    'Kids Duo'
  }

  let(:kid_params_for_create) {
    {name: '手巣戸 要介',
     school: '山葉小学校',
     email: 'test@kidsvillage.com',
     introduction: 'こんにちは。'}
  }

  before do
    log_in_as(user)
    visit user_path(user)
  end

  context 'user do not create facility' do
    it 'button to open the window for kid does not exist' do
      expect(page).not_to have_button '児童用のページを開く'
    end
  end

  context 'after user create facility' do
    before do
      click_link '新たに施設を追加する'
      fill_in '施設名', with: facility_name
      click_button '施設を追加する'
    end

    it 'exists button to open the window for kid on users' do
      expect(page).to have_button '児童用のページを開く'
    end

    it 'exists button to open the window for kid on facilities' do
      click_on facility_name
      expect(page).to have_button '児童用のページを開く'
    end

    it 'can click the button from users' do
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
      expect(current_url).to include('for_kid')
    end

    it 'can click the button from facilities' do
      click_on facility_name
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
      expect(current_url).to include('for_kid')
    end

    it 'there are no kid on the window for kid' do
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
      expect(page).not_to have_selector 'input.kid_name'
    end
  end

  context 'after user create kid on the facility' do
    before do
      click_link '新たに施設を追加する'
      sleep(3)
      fill_in '施設名', with: facility_name
      click_button '施設を追加する'
      click_on facility_name
      click_on '新たに児童を追加する'
      fill_in 'お名前', with: kid_params_for_create[:name]
      fill_in '学校', with: kid_params_for_create[:school]
      fill_in 'メールアドレス', with: kid_params_for_create[:email]
      fill_in '自己紹介', with: kid_params_for_create[:introduction]
      click_button '児童を追加する'
      visit user_path(user)
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
    end

    it 'there is a kid on the window for kid' do
      expect(page).to have_selector 'input.kid_name'
    end

    it 'can back to the show window for kid' do
      click_on kid_params_for_create[:name]
      page.driver.browser.manage.window.maximize
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title full_title(facility_name)
    end

    it 'can back to the kid detail for kid from edit window' do
      click_on kid_params_for_create[:name]
      page.driver.browser.manage.window.maximize
      expect(page).to have_button '自己紹介を変えたい!'
      click_on '自己紹介を変えたい!'
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title kid_params_for_create[:name]
    end

    it 'can edit the introduction' do
      click_on kid_params_for_create[:name]
      click_on '自己紹介を変えたい!'
      find(".form_control").set("こんにちは。よろしくお願いします。")
      click_on '自己紹介を変える！'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_selector 'input.kid_name'
    end

    it 'can send back_from_school email' do
      click_on kid_params_for_create[:name]
      expect(page).to have_button '学校から戻りました!'
      click_on '学校から戻りました!'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq [kid_params_for_create[:email]]
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_selector 'input.kid_name'
      expect(page).to have_title full_title(facility_name)

    end

    it 'can send finish_homework email' do
      click_on kid_params_for_create[:name]
      expect(page).to have_button '宿題が終わりました!'
      click_on '宿題が終わりました!'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq [kid_params_for_create[:email]]
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_selector 'input.kid_name'
      expect(page).to have_title full_title(facility_name)
    end


  end


end
