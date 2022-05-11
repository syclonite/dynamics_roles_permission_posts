class ManageAuthorize

  Permission_slug_list = {approve_employee:"approve-employee",
                     add_employee:"add-new-employee",
                     edit_employee:"edit-employee-profile",
                     delete_employee:"delete-employee-profile	",
                     read_employee:"read-employee-profile",
                     read_post:"read-post",
                     approve_post:"approve-post",
                     delete_post:"delete-post",
                     add_post:"add-post",
                     edit_post:"edit-post"}

  def verify_permission(u,p)
    has_permission(u,p)
  end

  private

  def has_permission(user,permissions)
    @current_user_id = User.find(user.id)
    @current_user_roles = @current_user_id.roles.pluck(:role_name).uniq
    @current_user_permission = @current_user_id.permissions.pluck(:permission_slug)
    return true if @current_user_roles.include?("Admin")
    return @current_user_permission.include?(permissions)
  end

end
