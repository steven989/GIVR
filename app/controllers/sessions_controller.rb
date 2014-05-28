class SessionsController < ApplicationController

    def create
        if login(params[:email], params[:password])
            redirect_back_or_to projects_path, notice: 'Login successful'
        else 
            flash[:login_error] = 'Your email or password is incorrect.'
            redirect_back_or_to projects_path+'#showLogin/login'
        end 
    end 

    def destroy
        logout

        redirect_back_or_to projects_path
    end 

end
