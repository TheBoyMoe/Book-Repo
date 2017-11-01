require 'rails_helper'

RSpec.describe "UsersProfiles", type: :request do
  include ApplicationHelper
  fixtures :all

  describe "GET /users/:id", type: :feature do

    let(:user) {users(:archer)}

    it "displays the contents of the user's profile" do
      visit user_path(user.id)

      expect(page.status_code).to eq(200)
      expect(page.current_path).to eq("/users/#{user.id}")
      expect(page.body).to have_title(full_title("#{user.name}"))
      expect(page.body).to have_selector('a', text: "#{user.name}")
      expect(page.body).to have_selector('img.gravatar')
      expect(page.body).to have_selector('div.pagination')
      user.microposts.paginate(page: 1).each do |post|
        expect(page.body).to have_selector('span.content', text: post.content)
      end
    end

  end
end
