require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest

  test "login_with_valid_user_receive_success_and_jwt" do
    post '/auth/login',
         params: {username: 'ppetrovic', password: 'harD2gue55'}
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['token'], 'JWT token is nil'
  end

  test "login_with_invalid_user_receive_unauthorized" do
    post '/auth/login',
         params: {username: 'IdoNotExist', password: 'harD2gue55'}
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert_equal json_response['error'], 'unauthorized', 'Received unexpected error message'
  end
end
