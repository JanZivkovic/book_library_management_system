class UsersController < ApplicationController
  before_action :authenticate_request
  before_action :check_user_role_librarian
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash, status: :ok
  end

  # GET /users/{id}
  def show
    render json: UserSerializer.new(@user).serializable_hash, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: { errors: @user.errors },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{id}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{id}
  def destroy
    begin
      @user.destroy
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: e.message }, status: :conflict
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :role_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_user_role_librarian
    if @current_user.role.name != 'LIBRARIAN'
      render json: { error: 'forbidden' }, status: :forbidden
    end
  end
end