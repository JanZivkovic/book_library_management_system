require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do

    #TODO: should be extracted into helper
    post auth_login_path, {params: {username: 'ppetrovic', password: 'harD2gue55'}}
    @token_member = JSON.parse(response.body)['token']

    post auth_login_path, {params: {username: 'pstijena', password: 'riirgjt45893'}}
    @token_librarian = JSON.parse(response.body)['token']
  end

  test "create user returns 401 unauthorized" do
    post users_url,
         params: {user: {name: 'Borko Perić', username: 'bperic', email: 'pb@ker.hr', password: 'harD2gue55', role_id: roles(:member).id}}
    assert_response :unauthorized
  end

  test "create user returns 403 forbidden" do
    post users_url,
         headers:{authorization: @token_member},
         params: {user: {name: 'Borko Perić', username: 'bperic', email: 'pb@ker.hr', password: 'harD2gue55', role_id: roles(:member).id}}
    assert_response :forbidden
  end

  test "create user succeeds" do
    post users_url,
         headers:{authorization: @token_librarian},
         params: {user: {name: 'Borko Perić', username: 'bperic', email: 'pb@ker.hr', password: 'harD2gue55', role_id: roles(:member).id}}
    assert_response :success
  end

end
