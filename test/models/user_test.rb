require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "can make a loan should return true" do
    user = users(:three)
    assert user.canMakeALoan? Date.today
  end

  test "can make a loan should return false" do
    user = users(:one)
    assert_not user.canMakeALoan? Date.today
  end

end
