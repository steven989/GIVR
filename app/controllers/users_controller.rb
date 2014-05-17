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

    def update
        @user = User.find_by(id: params[:id])
        @user.categories.delete_all
        @user.locations.delete_all
        @user.causes.delete_all
        params[:user][:category_ids].each do |category_id|
            @user.categories << Category.find_by(id:category_id) unless category_id == ""
        end
        params[:user][:location_ids].each do |location_id|
            @user.locations << Location.find_by(id:location_id) unless location_id == ""
        end
        params[:user][:cause_ids].each do |cause_id|
            @user.causes << Cause.find_by(id:cause_id) unless cause_id == ""
        end
        redirect_to user_profile_path, notice: 'Your preferences have been saved!'

    end

    def update_role
        @user = current_user
        if params[:user]
        @user.update_attribute(:role, params[:user][:role])
        flash[:notice] = 'Your role has been successfully set!'
        else
        flash[:notice] = 'Please set a role'
        end
        redirect_to user_profile_path
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
        @role = current_user.role
        if @role == 'npo'
            @projects = current_user.submitted_projects
            @applications = current_user.applications.order('created_at ASC').where("status not like 'shortlist'")
        elsif @role == 'professional'
            @projects = current_user.completed_projects
            @applications = current_user.made_applications.order('created_at ASC').where("status in ('apply','approve')")
            @shortlists = current_user.made_applications.order('created_at ASC').where("status in ('shortlist')")
        end
    end 

    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:resume)
    end 

end
