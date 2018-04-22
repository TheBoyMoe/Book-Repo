require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "votes have a story" do
    puts votes
    assert_equal stories(:one), votes(:one).story
  end

  # test the belongs_to relationship
  test "is associated with a user" do
    assert_equal users(:john), votes(:two).user
  end
end
