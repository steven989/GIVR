class SessionsController < ApplicationController

    def create
        redirect=params[:redirect]
        if login(params[:email], params[:password])
            if redirect == ""
                redirect_back_or_to projects_path, notice: 'Login successful'
            else
                redirect_to redirect, notice: 'Login successful'
            end
        else 
            flash[:login_error] = 'Your email or password is incorrect.'
            if redirect == ""
                redirect_back_or_to projects_path+'#showLogin/login', notice: 'Login successful'
            else
                redirect_to redirect+'#showLogin/login', notice: 'Login successful'
            end
        end 
    end 

    def destroy
        logout

        redirect_back_or_to projects_path
    end 

end
