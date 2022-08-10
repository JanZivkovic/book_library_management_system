class UsersController < ApplicationController
  before_action :authenticate_request
  before_action :check_user_role_librarian
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    @user.destroy
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