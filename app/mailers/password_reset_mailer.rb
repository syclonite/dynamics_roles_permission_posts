class PasswordResetMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_reset_mailer.password_reset.subject
  #
  def password_reset
    # @greeting = "Hi"
    @token= params[:user].to_sgid(purpose: "password_reset", expires_in: 15.minutes).to_s
    mail to: params[:user].email
  end
end
