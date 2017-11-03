require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :request do
  describe "GET /microposts_interfaces", type: :feature do

    before(:each) {
      # login user
    }

    it "works!" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "displays success message when a user posts content"

    it "displays an error message if no content is provided"

    it "displays an error message if content exceeds 140 characters"

    # test image upload listing 13.63
    it "displays an error message if the wrong file type is uploaded"

  end
end
