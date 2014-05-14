class UserMailer < ActionMailer::Base
  default from: "notifications@givr.com"

  def welcome_email(user)
    @user = user
    @url = "http://givr.com"
    mail(to: @user.email, subject: 'Welcome to GIVR!')
  end
end
