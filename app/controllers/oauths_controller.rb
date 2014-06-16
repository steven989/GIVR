class OauthsController < ApplicationController

  def oauth
    login_at(params[:provider])
  end

  def callback

    provider = params[:provider]
    if @user = login_from(provider)
        redirect_to projects_path, notice: "Logged in from #{provider.titleize}"
    else 
        begin
            puts "created user"
            @user = create_from(provider)

            reset_session #protect from session fixation attack
            auto_login(@user)
            redirect_to projects_path, notice: "Logged in from #{provider.titleize}"
        rescue
            puts "could not login"
            redirect_to projects_path, notice: "Failed to log in from #{provider.titleize}"
        end 
    end
  end

end
