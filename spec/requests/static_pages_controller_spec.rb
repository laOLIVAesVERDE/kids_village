require 'rails_helper'

RSpec.describe 'Access to static_pages', type: :request do
  context 'GET #home' do
    before { get static_pages_home_url }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Home | Ruby on Rails Sample App'" do
      expect(response.body).to include 'Home | Ruby on Rails Sample App'
    end
  end
  context 'GET #help' do
    before { get static_pages_help_path }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Home | Ruby on Rails Sample App'" do
      expect(response.body).to include 'Help | Ruby on Rails Sample App'
    end
  end
  context 'GET #about' do
    before { get static_pages_about_path }
    it 'responds successfully' do
      expect(response).to have_http_status 200
    end
    it "has title 'Home | Ruby on Rails Sample App'" do
      expect(response.body).to include 'About | Ruby on Rails Sample App'
    end
  end
  context 'GET #root' do
    it 'responds successfully' do
      get root_url
      expect(response).to have_http_status 200
    end
  end
end
