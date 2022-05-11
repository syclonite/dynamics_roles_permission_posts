class WelcomeController < ApplicationController
  def index
    @posts = Post.kept.where(status:1).order("created_at ASC").page(params[:page]).per(10)
  end

end
