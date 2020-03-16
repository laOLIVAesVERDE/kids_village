require 'rails_helper'

RSpec.describe 'access to users', type: :request do
  describe 'GET #new' do
    it 'responds successfully' do
      get signup_path
      expect(response).to have_http_status 200
    end
  end

  describe 'GET #login' do
    it 'responds successfully' do
      get login_path
      expect(response).to have_http_status 200
    end
  end
end
