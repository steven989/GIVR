    class SessionsController < ApplicationController


    def create
        if login(params[:email], params[:password])
            redirect_back_or_to projects_path, notice: 'Login successful'
        else 
            redirect_to projects_path+'#showLogin', notice: 'Your email or password is incorrect.'
        end 
    end 

    def destroy
        logout

        redirect_back_or_to projects_path
    end 

end
