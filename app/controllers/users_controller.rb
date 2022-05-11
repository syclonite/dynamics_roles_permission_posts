class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]
  load_and_authorize_resource
# rescue CanCan::AccessDenied
#   redirect_to root_url
  # GET /users or /users.json
  def index
    @users = User.all.order("id DESC").page(params[:page]).per(10)
    @users = User.kept.order("id DESC").page(params[:page]).per(10) if has_role(current_user,"junior-executive") || has_role(current_user,"hr-manager")
    @users = User.kept.where(status: nil).order("id ASC").page(params[:page]).per(10) if params[:approved_users_status] == ''
    @users = User.kept.where(status: params[:approved_users_status]).order("id ASC").page(params[:page]).per(10) if params[:approved_users_status].present?
    # User.fifth.user_role_permissions.includes(:role,:permission).pluck(:role_name,:permission_name) ** dont delete it is a query for getiing the associated name from rails console(not so important just i found it like a raw query)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    if has_role(current_user,"admin")
      @roles = Role.all
      @permissions = Permission.all
    else
      @roles = Role.where.not(slug:'admin',status:0)
      @permissions = Permission.kept.where.not(permission_slug:'super-admin',status:0)
    end
  end

  # GET /users/1/edit
  def edit
    if has_role(current_user,"admin")
      @roles = Role.all
      @permissions = Permission.all
    else
      @roles = Role.kept.where.not(slug:'admin',status:0)
      @permissions = Permission.kept.where.not(permission_slug:'super-admin',status:0)
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        params[:role_ids].each do |role|
          params[:permission_ids].each do |permission|
            UserRolePermission.create(user_id:@user.id, role_id:role, permission_id:permission)
          end
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        @user_role_permission = UserRolePermission.where(user_id:@user).destroy_all
        params[:role_ids].each do |role|
          params[:permission_ids].each do |permission|
            UserRolePermission.create(user_id:@user.id, role_id:role, permission_id:permission)
          end
        end

        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.discarded?
      @user.destroy
    else
      @user.discard
    end

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def restore_record
    # raise params[:restore].inspect
    @user = User.find(params[:restore])
    if @user.discarded?
      @user.update(discarded_at: nil)
    end
    redirect_to users_path, notice:"Record Restored"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:name, :slug, :email, :password, :approved_by, :status)
    end
end
