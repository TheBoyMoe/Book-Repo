require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    before do
      get :new
    end
    render_views

    it "returns http success" do
      expect(response).to have_http_status(:success)
      expect(response.body).to include(full_title('Login'))
    end
  end

end
