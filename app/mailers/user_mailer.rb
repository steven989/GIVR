class UserMailer < ActionMailer::Base
  default from: "notifications@givr.com"

  def welcome_email(user)
    @user = user
    @url = "http://givr.com"
    mail(to: @user.email, subject: 'Welcome to GIVR!')
  end

  def applied_to_project(user)
    @user = user
    @url = "http://givr.com"
    mail(to: @user.email, subject: 'Someone has applied to your project on Givr!')
  end

  def project_approved(user)
    @user = user
    @url = "http://givr.com"
    mail(to: @user.email, subject: 'Your Givr project has been approved!')
  end

  def reset_password_email(user)

    @user = user
    @url = edit_password_reset_url(user.reset_password_token)
    mail(to: user.email, subject: 'Reset your Givr password')

  end 

end
