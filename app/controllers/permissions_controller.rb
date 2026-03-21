
class PermissionsController < ApplicationController
  before_action :authenticate_user! # make sure only logged-in users can access
  before_action :authorize_admin!   # only admins can edit permissions

  def index
    @roles = ["admin", "manager", "staff", "employee"]
    @resources = ["members", "members/statement", "savings", "loans", "loan_repayments", "app_configs"]

    # Preload all permissions
    @permissions = Permission.all.index_by { |p| [p.role, p.resource] }

    # Ensure every role-resource has a record
    @roles.each do |role|
      @resources.each do |resource|
        @permissions[[role, resource]] ||= Permission.create(role: role, resource: resource)
      end
    end
  end

  def update
    params[:permissions].each do |role, resources|
      resources.each do |resource, actions|
        permission = Permission.find_or_initialize_by(role: role, resource: resource)
        permission.update(
          can_create: actions[:can_create] == "1",
          can_read:   actions[:can_read] == "1",
          can_update: actions[:can_update] == "1",
          can_delete: actions[:can_delete] == "1"
        )
      end
    end

    redirect_to permissions_path, notice: "Permissions updated successfully"
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user.role == "admin"
  end
end