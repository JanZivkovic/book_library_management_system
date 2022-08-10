require "test_helper"

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @author = authors(:terry_pratchett)
    @author_with_no_books = authors(:author_with_no_books)
    #TODO: should be extracted into helper
    post auth_login_path, {params: {username: 'ppetrovic', password: 'harD2gue55'}}
    @token_member = JSON.parse(response.body)['token']

    post auth_login_path, {params: {username: 'pstijena', password: 'riirgjt45893'}}
    @token_librarian = JSON.parse(response.body)['token']

  end

  test "should get index" do
    get authors_url, headers:{authorization: @token_librarian}, as: :json
    assert_response :success
  end

  test "should get index unauthorized" do
    get authors_url, as: :json
    assert_response :success
  end

  test "should create author" do
    assert_difference("Author.count") do
      post authors_url,
           headers:{authorization: @token_librarian},
           params: { author: {name: 'Don Huan Dela Puerta'  } },
           as: :json
    end

    assert_response :created
  end

  test "should not create author and should receive 403 Forbidden" do
    assert_no_difference("Author.count") do
      post authors_url,
           headers:{authorization: @token_member},
           params: { author: {name: 'Don Huan Dela Puerta'  } },
           as: :json
    end

    assert_response :forbidden
  end

  test "should show author" do
    get author_url(@author),as: :json

    assert_response :success
  end

  test "should update author" do
    assert_changes '@author.name' do
      patch author_url(@author),
           headers:{authorization: @token_librarian},
           params: {author: {name: "#{@author.name} Junior"  } },
           as: :json
      @author.reload
    end

    assert_response :success
  end

  test "should not update author and should get 403 Forbidden" do
    assert_no_changes '@author.name' do
      patch author_url(@author),
            headers:{authorization: @token_member},
            params: {author: {name: "#{@author.name} Junior"  } },
            as: :json
      @author.reload
    end

    assert_response :forbidden
  end

  test "should destroy author" do
    assert_difference("Author.count", -1, 'User with librarian role should be able to delete an author') do
      delete author_url(@author_with_no_books),
             headers:{authorization: @token_librarian},
             as: :json
    end

    assert_response :no_content
  end

  test "should not destroy author with books should get 409 conflict" do
    assert_no_difference('Author.count', 'Author that has associated books can\'t be destroyed') do
      delete author_url(@author),
             headers:{authorization: @token_librarian},
             as: :json
    end

    assert_response :conflict
  end

  test "should not destroy author and should get 403 Forbidden" do
    assert_no_difference("Author.count",
                         'User with member role should not be permitted to delete an author') do
      delete author_url(@author_with_no_books),
             headers:{authorization: @token_member},
             as: :json
    end

    assert_response :forbidden
  end

  test "should find one author by search" do
    get search_authors_path({q: 'Colour'}), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.size, 'List of returned books should contain one book'
    assert_equal 'Terry Pratchett', json[0]['name'], 'Wrong author returned'
  end

  test "should find zero authors by search" do
    get search_authors_path({q: 'ColourDolor'}), as: :json

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 0, json.size, 'List of returned books should be empty'
  end
end
