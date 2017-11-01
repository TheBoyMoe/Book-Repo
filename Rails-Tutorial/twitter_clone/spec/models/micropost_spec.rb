require 'rails_helper'

RSpec.describe Micropost, type: :model do

  fixtures :all

  describe "is a valid micropost" do
    let(:user){users(:michael)}
    let(:post){Micropost.new(content: 'dummy text content', user_id: user.id)}

    it "is a valid micropost" do
      expect(post).to be_valid
      expect(post).to respond_to(:content)
      expect(post).to respond_to(:user)
    end

    it "is associated with a user id" do
      post.user_id = nil
      expect(post).not_to be_valid
    end
  end

end
