require "test_helper"

class BookLoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_loan = book_loans(:one)

    #TODO: should be extracted into helper
    post auth_login_path, {params: {username: 'ppetrovic', password: 'harD2gue55'}}
    @token_member = JSON.parse(response.body)['token']

    post auth_login_path, {params: {username: 'pstijena', password: 'riirgjt45893'}}
    @token_librarian = JSON.parse(response.body)['token']
  end

  test "should get index" do
    get book_loans_url,
        headers:{ authorization: @token_librarian},
        as: :json
    assert_response :success
  end

  test "should not get index should receive 403 - Forbidden" do
    get book_loans_url,
        headers:{ authorization: @token_member},
        as: :json
    assert_response :forbidden
  end

  test "should not get index should receive 401 - Not authorized" do
    get book_loans_url,
        as: :json
    assert_response :not_authorized
  end

  test "should get loans for user" do
    get user_book_loans_url(users(:one)),
        headers:{ authorization: @token_member},
        as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json.size, 'Endpoint returned unexpected number of loans'
  end

  test "should get empty loan list" do
    get user_book_loans_url(users(:one)),
        headers:{ authorization: @token_librarian},
        as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 0, json.size, 'Loan list should be empty'
  end

  test "should create book_loan" do
    assert_difference("BookLoan.count") do
      post book_loans_url,
           headers:{ authorization: @token_librarian},
           params: {
             book_loan: { user_id: users(:one).id,
                          book_id: books(:the_colour_of_magic).id,
                          start_date: Date.today,
                          end_date: Date.today + 21.days}
           },
           as: :json
    end

    assert_response :created
  end

  test "should show book_loan" do
    get book_loan_url(@book_loan), as: :json
    assert_response :success
  end

  test "should update book_loan" do
    patch book_loan_url(@book_loan),
          headers:{ authorization: @token_librarian},
          params: { book_loan: { end_date: @book_loan.end_date + 21.days  } },
          as: :json
    assert_response :success
  end

  test "should destroy book_loan" do
    assert_difference("BookLoan.count", -1) do
      delete book_loan_url(@book_loan),
             headers:{ authorization: @token_librarian},
             as: :json
    end

    assert_response :no_content
  end
end
