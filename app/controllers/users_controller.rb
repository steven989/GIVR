class UsersController < ApplicationController

    def new
        @user = User.new
    end 

    def create

        @user = User.new(users_params)

        if @user.save
            # Tell the UserMailer to send a welcome email after save.

            UserMailer.welcome_email(@user).deliver

            auto_login(@user)
            redirect_to projects_path
        else 
            render :new
        end 

    end 

    def profile

        @user = current_user

    end 

    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role)
    end 

end
