require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  render_views

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
      assert_select "title", "ホーム | Kids Village"
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get :contact
      expect(response).to have_http_status(:success)
      assert_select "title", "Contact | Kids Village"
    end
  end

end
