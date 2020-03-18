require 'rails_helper'

RSpec.describe 'Access to static_pages', type: :request do
  include ApplicationHelper
  context 'GET #home' do
    before { get root_path }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Ruby on Rails Sample App'" do
      expect(response.body).to include full_title('')
    end
  end

  context 'GET #help' do
    before { get help_path }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Help | Ruby on Rails Sample App'" do
      expect(response.body).to include full_title('Help')
    end
  end

  context 'GET #about' do
    before { get about_path }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'About | Ruby on Rails Sample App'" do
      expect(response.body).to include full_title('About')
    end
  end

  context 'GET #contact' do
    before { get contact_url }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Contact | Ruby on Rails Sample App'" do
      expect(response.body).to include full_title('Contact')
    end
  end

end