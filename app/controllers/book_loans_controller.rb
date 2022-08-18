class BookLoansController < ApplicationController
  before_action :authenticate_request
  before_action :check_user_role_librarian, except: %i[ user_book_loans ]
  before_action :check_user_role_member, only: %i[ user_book_loans ]
  before_action :set_book_loan, only: %i[ show update destroy ]

  # GET /book_loans
  def index
    @book_loans = BookLoan.all

    render json: BookLoanSerializer.new(@book_loans).serializable_hash
  end

  # GET /book_loans/
  def user_book_loans
    @book_loans = @current_user.book_loans.order('created_at asc')

    render json: BookLoanSerializer.new(@book_loans).serializable_hash
  end

  # GET /book_loans/1
  def show
    render json: BookLoanSerializer.new(@book_loan).serializable_hash
  end

  # POST /book_loans
  def create
    @book_loan = BookLoan.new(book_loan_params)

    if @book_loan.book
      if !@book_loan.book.available_to_loan? Date.today
        render json: {error: 'All hard copies of the book have been lent'}, status: :unprocessable_entity and return
      end
    end

    if @book_loan.user
      if !@book_loan.user.can_make_a_loan? Date.today
        render json: {error: 'User has already lent 3 books'}, status: :unprocessable_entity and return
      end
    end

    if @book_loan.save
      render json: BookLoanSerializer.new(@book_loan).serializable_hash, status: :created, location: @book_loan
    else
      render json: @book_loan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /book_loans/1
  def update

    if book_loan_params['end_date'] && book_loan_params['end_date'].to_date > today
      render json: { error: 'end_date can not be greater then today.' }, status: :unprocessable_entity and return
    end

    if @book_loan.update(book_loan_params)
      render json: BookLoanSerializer.new(@book_loan).serializable_hash
    else
      render json: @book_loan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /book_loans/1
  def destroy
    @book_loan.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_loan
      @book_loan = BookLoan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_loan_params
      params.require(:book_loan).permit(:user_id, :book_id, :start_date, :end_date)
    end

    def check_user_role_librarian
      if @current_user.role.name != 'LIBRARIAN'
        render json: { error: 'forbidden' }, status: :forbidden
      end
    end

    def check_user_role_member
      if @current_user.role.name != 'MEMBER'
        render json: { error: 'forbidden' }, status: :forbidden
      end
    end
end
