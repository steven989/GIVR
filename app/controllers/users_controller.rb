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

    def profile

        

    end 

    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role)
    end 

end
