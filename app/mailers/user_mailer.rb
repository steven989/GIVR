class UserMailer < ActionMailer::Base
  default from: "info@givingly.me"

  def welcome_email(user)
    @user = user
    @givingly_web_address_index = projects_url
    @givingly_web_address_post_project = user_profile_url+"#_add-new"
    @givingly_contact_email = "info@givingly.me"
    @givingly_logo_address = "https://s3.amazonaws.com/givr-app/assets/givingly_nosplash_reduced.png"

    if user.is?('npo')
      template_name = 'welcome_email_npo'
    else
      template_name = 'welcome_email'
    end

    mail(
      to: @user.email, 
      subject: 'Welcome to Givingly: skill-based volunteering',
      template_path: 'user_mailer',
      template_name: template_name
      )
  end

  def applied_to_project(user,applicant,project)
    @user = user
    @applicant = applicant
    @project = project
    @givingly_web_address_applications = user_profile_url+"#_applications"
    @givingly_contact_email = "info@givingly.me"
    @givingly_logo_address = "https://s3.amazonaws.com/givr-app/assets/givingly_nosplash_reduced.png"

    mail(to: @user.email, subject: "Application to your Givingly project: #{@project.title}")
  end

  def project_approved(applicant,application)
    @applicant = applicant
    @application = application
    @givingly_web_address_applications = user_profile_url+"#_applications"
    @givingly_contact_email = "info@givingly.me"
    @givingly_logo_address = "https://s3.amazonaws.com/givr-app/assets/givingly_nosplash_reduced.png"

    mail(to: @applicant.email, subject: "Your application to Givingly project #{@application.project.title} has been approved")
  end

  def project_submission_approved(project)
    @project = project
    @givingly_web_address_index = projects_url
    @givingly_contact_email = "info@givingly.me"
    @givingly_logo_address = "https://s3.amazonaws.com/givr-app/assets/givingly_nosplash_reduced.png"

    mail(to: @project.user.email, subject: "Your Givingly project #{@project.title} has been approved")

  end

  def reset_password_email(user)

    @user = user
    @url = edit_password_reset_url(user.reset_password_token)
    @givingly_contact_email = "info@givingly.me"
    @givingly_logo_address = "https://s3.amazonaws.com/givr-app/assets/givingly_nosplash_reduced.png"
    
    mail(to: user.email, subject: 'Reset your Givingly password')

  end 

end
