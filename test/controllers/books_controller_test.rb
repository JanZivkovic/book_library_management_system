require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:the_colour_of_magic)
    @loaned_book = books(:has_been_loaned)

    #TODO: should be extracted into helper
    post auth_login_path, {params: {username: 'ppetrovic', password: 'harD2gue55'}}
    @token_member = JSON.parse(response.body)['token']

    post auth_login_path, {params: {username: 'pstijena', password: 'riirgjt45893'}}
    @token_librarian = JSON.parse(response.body)['token']
  end

  test "should get index" do
    get books_url, headers:{authorization: @token_member}, as: :json
    assert_response :success
  end

  test "should create book" do
    assert_difference("Book.count") do
      post books_url,
           headers:{authorization: @token_librarian},
           params: {book: {title: 'Equal Rites', author_id: authors(:terry_pratchett)[:id], hard_copies_count: 9  } },
           as: :json
    end

    assert_response :created
  end

  test "create book with user with member role should get 403 forbidden" do
    assert_no_changes("Book.count") do
      post books_url,
           headers:{authorization: @token_member},
           params: {book: {title: 'Equal Rites', author_id: authors(:terry_pratchett)[:id], hard_copies_count: 9  } },
           as: :json
    end

    assert_response :forbidden
  end

  test "show book to user with member role should succeed" do
    get book_url(@book), headers:{authorization: @token_member}, as: :json
    assert_response :success
  end

  test "update book by user with member role should get 403 forbidden" do
    patch book_url(@book),
          headers:{authorization: @token_member},
          params: { book: {hard_copies_count: @book[:hard_copies_count] + 1} },
          as: :json
    assert_response :forbidden
    old_value = @book[:hard_copies_count]
    @book.reload
    assert_equal old_value , @book[:hard_copies_count], 'hard_copies_count should be unchanged'
  end

  test "update book by user with librarian role should succeed" do
    patch book_url(@book),
          headers:{authorization: @token_librarian},
          params: { book: {hard_copies_count: @book[:hard_copies_count] + 1} },
          as: :json
    assert_response :success
    old_value = @book[:hard_copies_count]
    @book.reload
    assert_equal old_value + 1 , @book[:hard_copies_count], 'hard_copies_count should have increased by one'
  end

  test "destroy book by librarian user should succeed" do
    @book = books(:has_not_been_loaned)

    assert_difference("Book.count", -1) do
      delete book_url(@book), headers:{authorization: @token_librarian}, as: :json
    end

    assert_response :no_content
  end

  test "destroy book by member user should succeed" do
    @book = books(:has_not_been_loaned)

    assert_no_changes("Book.count") do
      delete book_url(@book), headers:{authorization: @token_member}, as: :json
    end

    assert_response :forbidden
  end

  test "destroy loaned book by librarian user should not succeed should get 409 Conflict" do
    @book = books(:has_not_been_loaned)

    assert_no_difference("Book.count", 'Book that has a loan record can\'t be deleted') do
      delete book_url(@loaned_book), headers:{authorization: @token_librarian}, as: :json
    end

    assert_response :conflict
  end

  test "search for books with query that should return list of distinct books" do
    get search_books_path({q: 'Terry'}), headers:{authorization: @token_member}, as: :json
    json = JSON.parse(response.body)
    assert_equal 3, json.size, 'Endpoint returned wrong number of books'
  end

  test "search for books with query that should return empty list" do
    get search_books_path({q: 'TerryDeri'}), headers:{authorization: @token_member}, as: :json
    json = JSON.parse(response.body)
    assert_equal 0, json.size, 'List of returned books should be empty'
  end

end
