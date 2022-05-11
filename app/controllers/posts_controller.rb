class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy]
  before_action :correct_user,only: %i[ show edit update destroy ]
  load_and_authorize_resource
  # GET /posts or /posts.json
  def index
    if has_role(current_user,"admin") || has_role(current_user,"manager")
      @posts = Post.all.order("id DESC").page(params[:page]).per(10)
      @posts = Post.where(status: nil).order("id DESC").page(params[:page]).per(10) if params[:approved_posts_status] == ''
      @posts = Post.where(status: params[:approved_posts_status]).order("id DESC").page(params[:page]).per(10) if params[:approved_posts_status].present?
    else
      @posts = current_user.posts.order("created_at DESC").page(params[:page]).per(10)
    end

  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(update_post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.discarded?
     @post.destroy
    else
      @post.discard
    end
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def restore_record
    # raise params[:restore].inspect
    @post = Post.find(params[:restore])
    if @post.discarded?
     @post.update(discarded_at: nil)
    end
    redirect_to posts_path, notice:"Record Restored"
  end

  def correct_user
    @post_correct_user = current_user.posts.find_by(id: params[:id])
    # @priority_user = has_role(current_user,"admin") || has_role(current_user,"manager")
    redirect_to posts_path, notice: "You Are Not Authorized" unless @post_correct_user.present? || has_role(current_user,"manager") || has_role(current_user,"admin")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:post_title, :slug, :status, :image, :user_id)
    end

   def update_post_params
     params.require(:post).permit(:post_title, :slug, :status, :image)
   end
end
