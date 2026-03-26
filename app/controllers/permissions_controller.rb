class PermissionsController < ApplicationController
  def index
    @roles = User::ROLES
    @resources = %w[members members/statement savings loans loan_repayments app_configs] # add all resources

    # Preload permissions or build defaults if missing
    @permissions = {}
    @roles.each do |role|
      @resources.each do |resource|
        permission = Permission.find_or_create_by(role: role, resource: resource) do |p|
          # defaults already handled in schema (false for all)
        end
        @permissions[[role, resource]] = permission
      end
    end
  end

  def create
    params[:permissions].each do |role, resources|
      resources.each do |resource, perms|
        permission = Permission.find_or_create_by(role: role, resource: resource)
        permission.update(
          can_create: perms[:can_create] == "1",
          can_read:   perms[:can_read]   == "1",
          can_update: perms[:can_update] == "1",
          can_delete: perms[:can_delete] == "1"
        )
      end
    end

    redirect_to permissions_path, notice: "Permissions updated successfully."
  end
end