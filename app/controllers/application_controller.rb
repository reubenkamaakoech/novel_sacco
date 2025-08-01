class ApplicationController < ActionController::Base
  # app/controllers/application_controller.rb
before_action :update_user_activity

def update_user_activity
  if current_user
    current_user.update_column(:last_seen_at, Time.current)
  end
end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
   
  # allow username to be creted when signing up
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :image])
  end
end
