class SessionsController < ApplicationController


    def create
        if login(params[:email], params[:password])
            redirect_back_or_to projects_path, notice: 'Login successful'
        else 
            render :new
        end 
    end 

    def destroy
        logout

        redirect_back_or_to projects_path
    end 

end
