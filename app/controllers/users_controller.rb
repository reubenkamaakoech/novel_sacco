class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :check_access
  
  def index
    @users = User.all
    @online_users = User.online
  end

  def edit
  end

  def show
  end

  def create
    user_count = User.count
    @user = User.new(user_params)
    @user.role = user_count.zero? ? "admin" : "employee"
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
  
  def check_access
    unless current_user&.access_granted?
      redirect_to root_path, alert: "You do not have access to this section."
    end
  end

  def toggle_status
  user = User.find(params[:id])

  # Prevent disabling the first created user
  if user == User.order(:created_at).first
    redirect_to users_path, alert: "You cannot change the status of the first admin user."
    return
  end

  user.update(status: !user.status)
  redirect_to users_path, notice: "User status updated."
end


  def toggle_access
  @user = User.find(params[:id])  # Finds the user by ID

  @user.update(access_granted: !@user.access_granted)  
  # Flips the current value of `access_granted`
  # If it was true, becomes false; if false, becomes true

  respond_to do |format|
    format.turbo_stream  # If using Turbo, this will stream an update to the view
    format.html { redirect_to users_path, notice: "Access updated." }  
    # Fallback: redirect with a flash notice
  end
end


  def check_admin
    redirect_to root_path, alert: "Admin access only." unless current_user&.admin?
  end

  private

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :role) # adjust as needed
  end
end
