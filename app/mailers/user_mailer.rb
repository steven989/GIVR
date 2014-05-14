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

  end
end
