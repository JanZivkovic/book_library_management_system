require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "can make a loan should return true" do
    user = users(:three)
    assert user.can_make_a_loan? Date.new(2022, 8, 1)
  end

  test "can make a loan should return false" do
    user = users(:one)
    assert_not user.can_make_a_loan? Date.new(2022, 8, 1)
  end

end
