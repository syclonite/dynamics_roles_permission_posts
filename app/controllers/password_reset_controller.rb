class PasswordResetController < ApplicationController

  def new
  end

  def create
    # raise params.inspect
    @user = User.find_by(email: params[:email])
    # raise @user.inspect
    if @user.present?
      PasswordResetMailer.with(user: @user).password_reset.deliver_later
    end
    redirect_to root_path, notice:"if an account with email was found. We have sent an email to reset the password"
  end

  def edit
    @user = GlobalID::Locator.locate_signed(params[:token],purpose:"password_reset")
    if @user == nil
      redirect_to root_url,alert:"The Token is expired after 15 min try again"
    end
    # binding.irb
    # @user = User.find(@user_signed_id.id)
    # raise @user_signed_id.inspect
  end

  def update
    @user = GlobalID::Locator.locate_signed(params[:token],purpose:"password_reset")
    if @user.update(password_reset)
    redirect_to root_path,notice:"Password has been reseted"
    end
  end

  def password_reset
    # raise params[:user].inspect
    params.require(:user).permit(:password)
  end

end
