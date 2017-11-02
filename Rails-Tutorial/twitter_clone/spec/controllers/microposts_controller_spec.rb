require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do

  fixtures :all
  let(:user) {users(:archer)}

  describe "#create", type: :feature do

    # REVIEW: post method for adding content
    xcontext "user not logged in" do
      it "micropost count remains unchanged, and the user is redirected to the login page" do
        count = Micropost.count
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
        count = user.microposts.count
        visit root_path
        fill_in 'micropost_content', with: "Chuck Norris can't test for equality because he has no equal."
        click_button 'Post'

        expect(user.microposts.count).to eq(count + 1)
      end
    end
  end

  # REVIEW: tests not working
  xdescribe "#destroy", js: true do
    # let(:post) { microposts(:tau_manifesto) }

    context "user is not logged in" do
      xit "micropost count remains unchanged, and the user is redirected to the login page" do
        count = Micropost.count
        page.driver.submit :delete, micropost_path(post), {}

        expect(Micropost.count).to eq(count)
        expect(page.current_path).to eq('/login')
      end

    end

    context "user is logged in" do
      let(:count) { user.microposts.count }
      let(:post2) { microposts(:orange) }

      before {
        visit login_path
        fill_in 'session_email', with: "#{user.email}"
        fill_in 'session_password', with: "password"
        click_button 'Log in'
      }

      it "micropost count is reduced by one when user tries to delete one of their own microposts" do
        post = user.microposts.first
        # binding.pry
        # within("li#micropost-#{post.id}")  do
        #   click_link 'delete'
        # end
        find("li#micropost-#{post.id}").find('a', text: 'delete').click
        accept_alert

        expect(user.microposts.count).to eq(count - 1)
        expect(page.current_path).to eq('/login')
      end

      it "micropost count is unchanged and the user is redirected to the 'root' when trying to delete someone else's micropost" do
        count = Micropost.count
        page.driver.submit :delete, micropost_path(post2), {}

        expect(Micropost.count).to eq(count)
        expect(page.curent_path).to eq('/')
      end
    end
  end
end
