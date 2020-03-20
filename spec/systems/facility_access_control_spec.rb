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



  context 'when user does not login' do
    it "cannot see user's facilities index" do
      visit user_path(user)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end

    it "cannot see user's facilities detail" do
      facility = user.facilities.create(name: 'Kids Duo')
      p facility.id
      visit facility_path(facility)
      expect(page).to have_selector 'div.alert-danger'
      expect(page).to have_content 'ログイン'
    end
  end
end
