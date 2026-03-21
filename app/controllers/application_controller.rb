class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Generic authorization
  def authorize_resource!(resource = nil)
    resource ||= resource_for_permission
    return unless current_user

    unless allowed?(current_user, resource, current_action_type)
      redirect_to root_path, alert: "Not authorized"
    end
  end

  def resource_for_permission
    # Map controllers to resources for Permission table
    case controller_name
    when "statements"
      "members/statement"
    else
      controller_name
    end
  end

  def allowed?(user, resource, action)
    return true if user.role == "admin"

    permission = Permission.find_by(role: user.role, resource: resource)
    return false unless permission

    case action
    when :create then permission.can_create
    when :read   then permission.can_read
    when :update then permission.can_update
    when :delete then permission.can_delete
    else false
    end
  end

  def current_action_type
    case action_name
    when "index", "show" then :read
    when "new", "create" then :create
    when "edit", "update" then :update
    when "destroy" then :delete
    else :read
    end
  end
end