require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  render_views

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
      assert_select "title", "ホーム | Ruby on Rails Sample App"
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | Ruby on Rails Sample App"
    end
  end

end
