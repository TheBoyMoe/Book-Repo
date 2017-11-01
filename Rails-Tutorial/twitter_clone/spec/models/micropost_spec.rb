require 'rails_helper'

RSpec.describe Micropost, type: :model do

  fixtures :all

  describe "is a valid micropost" do
    let(:user){users(:michael)}
    # let(:post){Micropost.new(content: 'dummy text content', user_id: user.id)}

    # idiomatic way of instantiating a micropost through its association with a user
    # 'build' is equivalent to 'new', automatically adds user_id
    let(:post){user.microposts.build(content: 'dummy content, dummy content, dummy content')}

    let(:most_recent){microposts(:most_recent)}

    it "is a valid micropost" do
      expect(post).to be_valid
      expect(post).to respond_to(:content)
      expect(post).to respond_to(:user)
    end

    it "is associated with a user id" do
      post.user_id = nil
      expect(post).not_to be_valid
    end

    it "ensures that content is present" do
      post.content = '    '

      expect(post).not_to be_valid
    end

    it "ensures that content is at most 140 characters in length" do
      post.content = 'a' * 141

      expect(post).not_to be_valid
    end

    it "ensures that the most recent micropost is returned first" do
      expect(Micropost.first).to eq(most_recent)
    end

    context "delete a user" do
      let(:user2) {User.create(name: 'test', email: 'test@ex.com', password: 'password')}
      before {
        user2.microposts.create(content: 'dummy content')
        user2.microposts.create(content: 'more dummy content')
        @count = Micropost.count
      }

      it "ensures a users microposts are destroyed" do
        user2.destroy

        expect(Micropost.count).to eq(@count - 2)
      end
    end

  end

end
