require 'rails_helper'

RSpec.describe 'user profile', type: :system do
  include ApplicationHelper

  let(:user) {
    create(:user,
           name: 's2000',
           email: 's2000@example.com',
           password: '12242339',
           password_confirmation: '12242339',
           admin: true)
  }


  context 'without login' do
    it 'user cannot access to profile' do
      visit user_path(user)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end
  end

  context 'after login' do
    before { log_in_as(user) }

    it 'can access to profile' do
      visit user_path(user)
      expect(page).to have_title full_title(user.name)
    end

    it 'profile has correct contents of user' do
      facility_names = ['Kids Duo', 'Los Ninos', 'はなまる', 'Play with us', 'もとーれ']
      facility_names.each do |facility_name|
        user.facilities.create!(name: facility_name)
      end
      expect(user.facilities.count).to eq 5
      user.reload
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_selector 'h3', text: "現在5つの施設を管理しています"
    end
  end
end
