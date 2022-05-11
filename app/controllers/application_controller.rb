class ApplicationController < ActionController::Base
  helper_method :check_permission, :has_role
  def check_permission(u,p)
    ManageAuthorize.new.verify_permission(u,p)
  end

  def has_role(u,roles)
    @user_id = User.find(u.id)
    return @user_id.roles.pluck(:slug).include?(roles)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
end
