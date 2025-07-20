class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully."
    else
      render :edit, alert: "Failed to update user."
    end
  end

  def destroy
    if @user != current_user
      @user.destroy
      redirect_to users_path, notice: "User deleted."
    else
      redirect_to users_path, alert: "You cannot delete yourself."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :admin) # adjust as needed
  end

  def check_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end
end
