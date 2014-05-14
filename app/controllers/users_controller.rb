class UsersController < ApplicationController

    def new
        @user = User.new
    end 

    def create

        @user = User.new(users_params)

        if @user.save
            auto_login(@user)
            redirect_to projects_path
        else 
            render :new
        end 

    end 


    def upload_resume

        @user = current_user
        
        if params[:resume_action] == 'upload'
            @user.update_attribute(:resume, params[:user][:resume])
        elsif params[:resume_action] == 'remove'
            @user.remove_resume!
            @user.save            
        end

        redirect_to user_profile_path
    end 

    def profile

        @user = current_user

    end 

    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:resume)
    end 

end
