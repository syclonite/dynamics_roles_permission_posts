class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_permission, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  # GET /permissions or /permissions.json
  def index
    @permissions = Permission.all.order("id ASC").page(params[:page]).per(10)
    @permissions = Permission.where(status: nil).order("id ASC").page(params[:page]).per(10) if params[:approved_permissions_status] == ''
    @permissions = Permission.where(status: params[:approved_permissions_status]).order("id ASC").page(params[:page]).per(10) if params[:approved_permissions_status].present?
  end

  # GET /permissions/1 or /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully created." }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to permission_url(@permission), notice: "Permission was successfully updated." }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    if @permission.discarded?
      @permission.destroy
    else
      @permission.discard
    end
    respond_to do |format|
      format.html { redirect_to permissions_url, notice: "Permission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def restore_record
    # raise params[:restore].inspect
    @permission = Permission.find(params[:restore])
    if @permission.discarded?
      @permission.update(discarded_at: nil)
    end
    redirect_to permissions_path, notice:"Record Restored"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def permission_params
      params.require(:permission).permit(:permission_name, :permission_slug, :status, :flag)
    end
end
