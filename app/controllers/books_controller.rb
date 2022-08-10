class BooksController < ApplicationController
  before_action :authenticate_request, except: %i[ search index show ]
  before_action :check_user_role_librarian, except: %i[ search index show ]
  before_action :set_book, only: %i[ show update destroy ]

  # GET /books
  def index
    @books = Book.all

    render json: @books
  end

  # GET /books/1
  def show
    render json: @book
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1
  def destroy
    begin
      @book.destroy
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: e.message }, status: :conflict
    end
  end

  def search
    @books = Book.joins(:author).where(
      'lower(books.title) like ? or lower(authors.name) like ?',
      '%' + Book.sanitize_sql_like(params[:q].downcase) + '%',
      '%' + Book.sanitize_sql_like(params[:q].downcase) + '%').distinct

    render json: @books
  end

  def out_of_stock
    @books = Book.out_of_stock params[:date].to_date
    render json: @books
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :hard_copies_count, :author_id)
    end

    def out_of_stock_params
      params.require(:date)
    end

    def check_user_role_librarian
      if @current_user.role.name != 'LIBRARIAN'
        render json: { error: 'forbidden' }, status: :forbidden
      end
    end
end
