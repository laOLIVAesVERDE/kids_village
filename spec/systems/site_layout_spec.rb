require 'rails_helper'

RSpec.describe 'site layout', type: :system do
  include ApplicationHelper

  context 'access to root_path' do
    before { visit root_path }
    subject { page }
    it 'has links such as root_path, help_path, about_path and contact_path' do
      is_expected.to have_link nil, href: root_path
      is_expected.to have_link 'ヘルプ', href: help_path
      is_expected.to have_link '問合せ', href: contact_path
    end
  end

  context 'access to signup_path' do
    before { visit signup_path }
    subject { page }
    it "has content 'Kids Villageへようこそ' and title 'Sign up'" do
      is_expected.to have_content "アカウント作成"
      is_expected.to have_title full_title('Sign up')
    end
  end
end
