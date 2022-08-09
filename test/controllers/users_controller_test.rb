require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "can_create_user" do
    post users,
         params: {name: 'Borko Perić', username: 'bperic', email: 'pb@ker.hr', password: 'harD2gue55', role_id: roles(:member).id}
    assert_response :success
  end

end
