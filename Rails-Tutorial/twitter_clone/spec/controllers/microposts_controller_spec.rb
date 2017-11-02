require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  fixtures :all
  let(:count) { Micropost.count }
  let(:user) {users(:archer)}

  describe "#create", type: :feature do

    context "user not logged in" do
      it "micropost count remains unchanged, and the user is redirected to the login page" do
        page.driver.submit :post, microposts_path, { micropost: { content: "Chuck Norris can't test for equality because he has no equal." }}

        expect(Micropost.count).to eq(count)
        expect(page.current_path).to eq('/login')
      end

    end

    context "user is logged in" do
      before {
        visit login_path
        fill_in 'session_email', with: "#{user.email}"
        fill_in 'session_password', with: "password"
        click_button 'Log in'
      }

      it "micropost count will increase by one" do
        page.driver.submit :post, microposts_path, { micropost: { content: "Chuck Norris can't test for equality because he has no equal." }}

        expect(Micropost.count).to eq(count + 1)
      end
    end
  end

  describe "#destroy", type: :feature do
    let(:post) { microposts(:orange) }

    context "user is not logged in" do
      it "micropost count remains unchanged, and the user is redirected to the login page" do
        page.driver.submit :delete, micropost_path(post), {}

        expect(Micropost.count).to eq(count)
        expect(page.current_path).to eq('/login')
      end

    end

    context "user is logged in" do
      before {
        visit login_path
        fill_in 'session_email', with: "#{user.email}"
        fill_in 'session_password', with: "password"
        click_button 'Log in'
      }

      it "micropost count is reduced by one" do
        page.driver.submit :delete, micropost_path(post), {}

        expect(Micropost.count).to eq(count - 1)
        expect(page.current_path).to eq('/login')
      end
    end
  end
end
