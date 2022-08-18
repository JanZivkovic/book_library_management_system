class AuthorsController < ApplicationController

  before_action :authenticate_request, except: %i[ search index show ]
  before_action :check_user_role_librarian, except: %i[ search index show ]
  before_action :set_author, only: %i[ show update destroy ]

  # GET /authors
  def index
    @authors = Author.all

    render json: AuthorSerializer.new(@authors).serializable_hash
  end

  # GET /authors/1
  def show
    render json: AuthorSerializer.new(@author).serializable_hash
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      render json: AuthorSerializer.new(@author).serializable_hash, status: :created, location: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authors/1
  def update
    if @author.update(author_params)
      render json: AuthorSerializer.new(@author).serializable_hash
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # DELETE /authors/1
  def destroy
    begin
      @author.destroy
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: e.message }, status: :conflict
    end
  end

  def search
    @authors = Author.joins(:books).where(
      'lower(authors.name) like :search_text or lower(books.title) like :search_text',
      {search_text: '%' + Author.sanitize_sql_like(params[:q].downcase) + '%'}) .distinct

    render json: AuthorSerializer.new(@authors).serializable_hash
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.require(:author).permit(:name)
    end

    def check_user_role_librarian
      if @current_user.role.name != 'LIBRARIAN'
        render json: { error: 'forbidden' }, status: :forbidden
      end
    end
end
