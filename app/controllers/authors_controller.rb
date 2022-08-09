class AuthorsController < ApplicationController

  before_action :authenticate_request, except: %i[ index show search]
  before_action :check_user_permissions, only: %i[ create update destroy ]
  before_action :set_author, only: %i[ show update destroy ]

  # GET /authors
  def index
    @authors = Author.all

    render json: @authors
  end

  # GET /authors/1
  def show
    render json: @author
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      render json: @author, status: :created, location: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authors/1
  def update
    if @author.update(author_params)
      render json: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # DELETE /authors/1
  def destroy
    begin
      @author.destroy
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: 'Foreign key constraint violated.' }, status: :conflict
    end

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

    def check_user_permissions
      if @current_user.role.name != 'LIBRARIAN'
        render json: { error: 'forbidden' }, status: :forbidden
      end
    end
end
