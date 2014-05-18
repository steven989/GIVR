class PasswordResetsController < ApplicationController
  
  #sends an email to the user
  def create
    
    @user = User.find_by(email: params[:email])
    @user.deliver_reset_password_instructions! if @user
    redirect_to projects_path, notice: 'Instructions have been sent to your email.'

  end


  # password reset form
  def edit

    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    if @user.blank?
        not_authenticated
        return
    end 
  end

  def update

    @token = params[:token]
    @user = User.load_from_reset_password_token(params[:token])

    if @user.blank?
        not_authenticated
        return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
        redirect_to projects_path, noitce: "Your password has been updated."
    else
        render :edit, notice: "Your password could not be updated."
    end

  end
end
