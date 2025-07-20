class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def toggle_sign_ups
    setting = Setting.first_or_create(sign_ups_enabled: false)
    setting.update(sign_ups_enabled: !setting.sign_ups_enabled?)
    redirect_back fallback_location: root_path, notice: "Sign up setting updated."
  end

  private

  def require_admin!
    # You can change this logic to fit your app — for example,
    # allow only the first user or a specific admin role
    unless current_user == User.first
      redirect_to root_path, alert: "Access denied."
    end
  end
end
