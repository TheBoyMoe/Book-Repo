require 'test_helper'

class VoteTest < ActiveSupport::TestCase

  test "votes have a story" do
    # stories and votes methods refer to the fixture files of the same name
    assert_equal stories(:one), votes(:one).story
  end

end
