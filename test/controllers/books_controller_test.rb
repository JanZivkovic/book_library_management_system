require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:the_colour_of_magic)
    post '/auth/login', {params: {username: 'ppetrovic', password: 'harD2gue55'}}
    @token = JSON.parse(response.body)['token']
  end

  test "should get index" do
    get books_url, headers:{authorization: @token}, as: :json
    assert_response :success
  end

  test "should create book" do
    assert_difference("Book.count") do
      post books_url,
           headers:{authorization: @token},
           params: {book: {title: 'Equal Rites', author_id: authors(:terry_pratchett)[:id], hard_copies_count: 9  } },
           as: :json
    end

    assert_response :created
  end

  test "should show book" do
    get book_url(@book), headers:{authorization: @token}, as: :json
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book),
          headers:{authorization: @token},
          params: { book: {hard_copies_count: @book[:hard_copies_count] + 1} },
          as: :json
    assert_response :success
    old_value = @book[:hard_copies_count]
    @book.reload
    assert_equal old_value + 1, @book[:hard_copies_count], 'hard_copies_count didn\'t update properly'
  end

  test "should destroy book" do
    @book = books(:has_not_been_loaned)
    assert_difference("Book.count", -1) do
      delete book_url(@book), headers:{authorization: @token}, as: :json
    end

    assert_response :no_content
  end

  test "should return list of distinct books" do
    get search_books_path({q: 'Terry'}), headers:{authorization: @token}, as: :json
    json = JSON.parse(response.body)
    assert_equal 3, json.size, 'Endpoint returned wrong number of books'
  end

end
