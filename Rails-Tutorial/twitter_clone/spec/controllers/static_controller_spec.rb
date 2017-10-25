require 'rails_helper'

RSpec.describe StaticController, type: :controller do

  describe "GET #home" do
    before(:example) {get :home}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "has a title element with the text 'Home | Twitter Clone App'" do
      expect(response.body).to include(full_title('Home'))
    end
  end

  describe "GET #help" do
    before(:example) {get :help}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(200)
    end

    it "has a title tag with the text 'Help | Twitter Clone App'" do
      expect(response.body).to include(full_title('Help'))
    end
  end

  describe "GET #about" do
    before(:example) {get :about}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(200)
    end

    it "has a title tag with the text 'About | Twitter Clone App'" do
      expect(response.body).to include(full_title('About'))
    end
  end

  describe "GET #contact" do
    before(:example){get :contact}
    render_views

    it "returns http success" do
      expect(response).to have_http_status(:ok)
    end

    it "has a title tag with the text 'Contact | Twitter Clone App'" do
      expect(response.body).to include(full_title('Contact'))
    end
  end

end
