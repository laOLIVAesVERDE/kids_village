require 'rails_helper'

RSpec.describe 'post access control spec', type: :system do
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
    {name: '本田 太郎',
     school: '本田第一小学校',
     email: 'taro_honda@kidsvillage.com',
     introduction: 'こんにちは'}
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

  let(:other_post) {
    create(:post,
           title: '今日の出来事',
           content: '今日は赤城公園に行ってきました',
           facility_id: other_facility.id)
  }


  context 'when user does not login' do
    let(:post) {
      create(:post,
             title: post_params_for_create[:title],
             content: post_params_for_create[:content],
             facility_id: facility.id)
    }

    it 'cannot see his own posts index' do
      visit facility_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot see post detail' do
      visit facility_post_path(facility, post)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot create post' do
      visit new_facility_post_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it 'cannot edit post info' do
      visit edit_facility_post_path(facility, post)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end
  end


  context 'when user login and create first facility' do

    before do
      log_in_as(user)
      visit facility_path(facility)
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
    end

    it 'cannot create post without invalid input' do
      click_link '新たに日記を作成する'
      expect(page).to have_content '日記作成'
      fill_in 'タイトル', with: ' '
      fill_in '内容', with: ' '
      click_button '日記を作成する'
      expect(Post.count).to eq(0)
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can create post with valid input' do
      click_link '新たに日記を作成する'
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_button '日記を作成する'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(post_params_for_create[:title])
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    it 'can create post including kid select' do
      click_link '新たに日記を作成する'
      select kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: kid_params_for_create[:name])
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_on '日記を作成する'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(post_params_for_create[:title])
    end

    it 'can create post including kid select multiple' do
      click_link '新たに日記を作成する'
      select kid_params_for_create[:name], from: 'post[kid_ids][]'
      select other_kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: [ kid_params_for_create[:name],
                                  other_kid_params_for_create[:name] ])
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_on '日記を作成する'
      expect(ActionMailer::Base.deliveries.size).to eq 2
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(post_params_for_create[:title])
    end

    it 'can unselect kid' do
      click_link '新たに日記を作成する'

      select kid_params_for_create[:name], from: 'post[kid_ids][]'
      select other_kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: [ kid_params_for_create[:name],
                                  other_kid_params_for_create[:name] ])

      unselect other_kid_params_for_create[:name], from: 'post[kid_ids][]'
      expect(page).to have_select('post[kid_ids][]',
                                  selected: kid_params_for_create[:name])

      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_on '日記を作成する'
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(post_params_for_create[:title])
    end


    it 'cannot see other post detail' do
      visit facility_post_path(other_facility, other_post)
      expect(page).to have_title('ホーム')
    end

    it 'cannot edit other post' do
      visit edit_facility_post_path(other_facility, other_post)
      expect(page).to have_title('ホーム')
    end

  end

  context 'when user creates first post on his/her facility' do

    before do
      log_in_as(user)
      visit facility_path(facility)
      click_link '新たに日記を作成する'
      fill_in 'タイトル', with: post_params_for_create[:title]
      fill_in '内容', with: post_params_for_create[:content]
      click_button '日記を作成する'
    end

    it 'can see post detail' do
      click_link post_params_for_create[:title]
      expect(page).to have_title full_title("日記詳細")
    end

    it 'cannot edit with invalid input' do
      find('.edit_icon').click
      fill_in 'タイトル', with: ' '
      fill_in '内容', with: ' '
      click_button '保存する'
      expect(page).to have_selector 'div.field_with_errors'
      expect(page).to have_selector 'div#error_explanation'
    end

    it 'can edit post with valid input' do
      edit_title = "今日の思い出"
      find('.edit_icon').click
      fill_in 'タイトル', with: edit_title
      fill_in '内容', with: '今日はみんなでたこ焼きを作りました。おいしかったです。'
      click_button '保存する'
      expect(page).to have_selector 'div.alert-success'
      expect(page).to have_content(edit_title)
    end

    it 'can destroy post' do
      find('.edit_icon').click
      click_link '削除する'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector 'div.alert-success'
      expect(facility.posts.count).to eq 0
    end
  end


end
