require 'rails_helper'

RSpec.describe StaticController, type: :controller do

  describe "GET #home" do
    before(:example) {get :home}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "has a title element with the text 'Home | Twitter Clone App'" do
      expect(response.body).to include("<title>Home | Twitter Clone App</title>")
    end
  end

  describe "GET #help" do
    before(:example) {get :help}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(200)
    end

    it "has a title tag with the text 'Help | Twitter Clone App'" do
      expect(response.body).to include('<title>Help | Twitter Clone App</title>')
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(200)
    end
  end

end
