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

  let(:other_kid_params_for_create) {
    {name: '本田 花子',
    school: '本田第二小学校',
    email: 'hanako_honda@kidsvillage.com',
    introduction: 'こんにちは'}
  }

  let(:post_params_for_create) {
    {title: '今日の出来事',
     content: "今日は大山公園に行ってきました。"}
  }

  before do
    log_in_as(user)
    visit user_path(user)
  end

  context 'when user do not create facility' do
    it 'button to open the window for kid does not exist' do
      expect(page).not_to have_button '児童用のページを開く'
    end
  end

  context 'after user create facility' do
    before do
      click_link '新たに施設を追加する'
      sleep(3)
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
      create_kid(facility,
                 kid_params_for_create[:name],
                 kid_params_for_create[:school],
                 kid_params_for_create[:email],
                 kid_params_for_create[:introduction]
      )
      create_kid(facility,
                 other_kid_params_for_create[:name],
                 other_kid_params_for_create[:school],
                 other_kid_params_for_create[:email],
                 other_kid_params_for_create[:introduction]
      )
      visit user_path(user)
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
    end

    it 'there is a kid on the window for kid' do
      expect(page).to have_selector 'input.kid_name'
    end

    it 'can back to the facility show for kid from kid show for kid' do
      click_on kid_params_for_create[:name]
      page.driver.browser.manage.window.maximize
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title full_title(facility_name)
    end

    it 'can back to the kid detail for kid from edit window' do
      click_on kid_params_for_create[:name]
      page.driver.browser.manage.window.maximize
      find("input[alt='Introduction']").click
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title kid_params_for_create[:name]
    end

    it 'can edit the introduction' do
      click_on kid_params_for_create[:name]
      find("input[alt='Introduction']").click
      find(".form_control").set("こんにちは。よろしくお願いします。")
      click_on '自己紹介を変える！'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_selector 'input.kid_name'
    end

    it 'can send back_from_school email' do
      click_on kid_params_for_create[:name]
      find("input[alt='School']").click
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
      find("input[alt='Homework']").click
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq [kid_params_for_create[:email]]
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_selector 'input.kid_name'
      expect(page).to have_title full_title(facility_name)
    end

    it 'can back to facility show for kid from post new for kid' do
      find("input[alt='Write post']").click
      page.driver.browser.manage.window.maximize
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title full_title(facility_name)
    end

    it 'cannot create post with invalid input' do
      find("input[alt='Write post']").click
      expect(page).to have_content '日記を書こう！'
      fill_in 'タイトル', with: ' '
      fill_in '内容', with: ' '
      click_button '日記を書きました！'
      expect(Post.count).to eq(0)
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can create post with valid input' do
      find("input[alt='Write post']").click
      expect(page).to have_content '日記を書こう！'
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_button '日記を書きました！'
      expect(page).to have_selector 'div.alert-success'
      expect(ActionMailer::Base.deliveries.size).to eq 0
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_title full_title(facility_name)
    end

    it 'can create post including kid select' do
      find("input[alt='Write post']").click
      expect(page).to have_content '日記を書こう！'
      select kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: kid_params_for_create[:name])
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_on '日記を書きました！'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_title full_title(facility_name)
    end

    it 'can create post including kid select multiple' do
      find("input[alt='Write post']").click
      expect(page).to have_content '日記を書こう！'
      select kid_params_for_create[:name], from: 'post[kid_ids][]'
      select other_kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: [ kid_params_for_create[:name],
                                  other_kid_params_for_create[:name] ])
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_on '日記を書きました！'
      expect(ActionMailer::Base.deliveries.size).to eq 2
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_selector '.back_icon'
      find('.back_icon').click
      expect(page).to have_title full_title(facility_name)
    end
  end

  context 'after create post on the facility' do
    before do
      create_kid(facility,
                 kid_params_for_create[:name],
                 kid_params_for_create[:school],
                 kid_params_for_create[:email],
                 kid_params_for_create[:introduction]
      )
      create_kid(facility,
                 other_kid_params_for_create[:name],
                 other_kid_params_for_create[:school],
                 other_kid_params_for_create[:email],
                 other_kid_params_for_create[:introduction]
      )
      visit user_path(user)
      click_button '児童用のページを開く'
      windows = page.driver.browser.window_handles
      page.driver.browser.switch_to.window(windows.last)
      find("input[alt='Write post']").click
      expect(page).to have_content '日記を書こう！'
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_button '日記を書きました！'
      find('.back_icon').click
    end

    it 'can see post index' do
      find("input[alt='See post']").click
      expect(page).to have_content post_params_for_create[:title]
      expect(page).to have_button 'くわしく見る'
    end

    it 'can back to facility show for kid from post index for kid' do
      find("input[alt='See post']").click
      expect(page).to have_content post_params_for_create[:title]
      expect(page).to have_button 'くわしく見る'
      page.driver.browser.manage.window.maximize
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_title full_title(facility_name)
    end

    it 'can see post detail' do
      find("input[alt='See post']").click
      expect(page).to have_content post_params_for_create[:title]
      expect(page).to have_button 'くわしく見る'
      click_on 'くわしく見る'
      expect(page).to have_content post_params_for_create[:title]
      expect(page).to have_content post_params_for_create[:content]
    end

    it 'can back to post index for kid from post show for kid' do
      find("input[alt='See post']").click
      click_on 'くわしく見る'
      expect(page).to have_selector '.back_icon'
      find("input[alt='Back icon']").click
      expect(page).to have_button 'くわしく見る'
      expect(page).to have_title full_title('日記一覧')
    end
  end


end
