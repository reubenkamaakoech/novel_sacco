class AppConfigsController < ApplicationController
  before_action :authenticate_user!

  def index
    @app_config = AppConfig.all
  end

  def edit
    # load first config or create one if none exists
    @config = AppConfig.first_or_create!(locked_savings_percentage: 0, user: current_user)
  end

  def update
    @config = AppConfig.first_or_create!(locked_savings_percentage: 0, user: current_user)
    if @config.update(app_config_params)
      redirect_to edit_app_config_path, notice: "Settings updated successfully."
    else
      render :edit
    end
  end

  private

  def app_config_params
    params.require(:app_config).permit(:locked_savings_percentage, :user_id)
  end
end