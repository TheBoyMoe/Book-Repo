require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test has_many association, has_many :stories
  test "has a story association" do
    assert_equal 2, users(:glenn).stories.size
    # ensure that a particular story obj is associated with a user
    assert users(:glenn).stories.includes stories(:one)
  end

  # a user has_many :votes
  test "has a votes association" do
    assert_equal 1, users(:glenn).votes.size
    assert users(:john).votes.includes votes(:two)
  end

	test "voted on association" do
    assert_equal [ stories(:one) ],
      users(:glenn).stories_voted_on
  end
end
