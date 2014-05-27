class UsersController < ApplicationController

    before_filter :require_login
    skip_before_filter :require_login, only: [:new, :create]

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
        @user = current_user
        if @user.role == 'professional'
            if @user.update_attributes(professional_params)
                message = 'Information successfully updated.'                
            else 
                message = 'Information could not be updated.'+@user.errors.full_messages.join(" ")                
            end

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

        elsif @user.role == 'npo'
            if @user.update_attributes(npo_params)
                message = 'Information successfully updated.'                
            else
                message = 'Information could not be updated.'+@user.errors.full_messages.join(" ")                
            end
        end

        redirect_to user_profile_path+'#settings', notice: message
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
        if params[:user] && params[:resume_action] == 'upload'
            @user.update_attribute(:resume, params[:user][:resume])
            if !@user.resume.file.nil?
                if @user.resume.file.exists?   
                    @user.update_attribute(:resume_quick_look, 'exists')
                    message = "Resume saved."
                    successflag = 1
                else
                    message = "Resume could not be saved. #{@user.errors.full_messages.join(" ")}" if @user.errors.any?
                    successflag = 0
                end
            else
                message = "Resume could not be saved. #{@user.errors.full_messages.join(" ")}" if @user.errors.any?
                successflag = 0
            end
        elsif params[:resume_action] == 'remove'
            @user.remove_resume!
            @user.save
            @user.update_attribute(:resume_quick_look, nil)
            message = "Resume removed."
        end

        respond_to do |format|
            format.html {redirect_to user_profile_path, notice: message}
            format.json {   self.formats = ['html']
              render json: { 
                  replaceWith: render_to_string(partial: 'users/resume_upload', layout: false, locals: {user: @user}),
                  message: message,
                  successflag: successflag
                      } 
          }
        end
    end 

    def upload_logo
        @user = current_user
        if params[:user] && params[:logo_action] == 'upload'
            @user.update_attribute(:logo, params[:user][:logo])
            message = "Logo could not be saved. #{@user.errors.full_messages.join(" ")}" if @user.errors.any?
        elsif params[:logo_action] == 'remove'
            @user.remove_logo!
            @user.save  
        end

        respond_to do |format|
            format.html {redirect_to user_profile_path, notice: message}
            format.json {   self.formats = ['html']
              render json: { 
                  replaceWith: render_to_string(partial: 'users/logo_upload', layout: false, locals: {user: @user}),
                  message: message
                      } 
          }
        end
    end

    def profile
        @user = current_user
        @role = current_user.role
        if @role == 'npo'
            @projects = current_user.submitted_projects
            @applications = current_user.applications.order('created_at ASC').where("applications.status not like 'shortlist'")
        elsif @role == 'professional'
            @projects = current_user.completed_projects
            @applications = current_user.made_applications.order('created_at ASC').where("applications.status in ('apply','approve', 'engage')")
            @shortlists = current_user.made_applications.order('created_at ASC').where("applications.status in ('shortlist')")
            @completed_applications = current_user.made_applications.order('created_at ASC').where("applications.status in ('complete')")
            @number_completed_applications = @completed_applications.length
            @points = current_user.points
        end
    # a series of variables for displaying charts. Output are in the form of array of arrays
        #npos
        if current_user.role == 'npo'
        #chart showing the top five projects and their total views in the last four weeks

            #1) Find projects by their total views in the last four weeks
            
            num_proj_show =  3 
            @num_weeks_show =  4
            array_of_top_project_ids = ProjectView.find_by_sql(["SELECT a.project_id, count(*) as views FROM project_views a LEFT JOIN projects b on a.project_id = b.id where b.user_id = ? AND view_start_time>=?::date GROUP BY project_id ORDER BY views DESC", current_user.id, (Time.now - (@num_weeks_show*7.days)).at_beginning_of_week]).take(num_proj_show).map {|project| [project.project_id,project.views]}
            
            if array_of_top_project_ids.length > 0
            #2) Turn into a hash in the form of {project_id => [[week1, view], [week2,view]]}
            @project_view = Hash.new { |this_hash, nonexistent_key| this_hash[nonexistent_key] = [] }  #this is the code to actually allow us to use << to assign into the arrays that are default value of the non-existent hash nonexistent_key
            array_of_dates = @num_weeks_show.times.map {|subtract| Time.now - (subtract*7.days)}.reverse

            array_of_top_project_ids.each { |project_id,views|
                array_of_dates.each { |date|
                    @project_view[project_id] << [(date.at_beginning_of_week.strftime('%Y-%m-%d').to_s)+' to '+((date.at_beginning_of_week+6.days).strftime('%Y-%m-%d').to_s),ProjectView.find_by_sql(["SELECT count(a.*) as views FROM project_views a WHERE a.project_id = ? AND a.view_start_time between date_trunc('week', ?::date)::date and (date_trunc('week', ?::date)::date + '6 days'::interval)::date",project_id,date.to_date,date.to_date]).map {|week| week.views}[0]]
                }
            }

            @y_max = array_of_top_project_ids[0][1]
            end

        end

    end 


    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:resume)
    end 

    def professional_params
        params.require(:user).permit(:email,:contact_first_name,:contact_last_name,:phone,:years_of_experience,:website)
    end

    def npo_params
        params.require(:user).permit(:email,:org_name,:mission,:contact_first_name,:contact_last_name,:organization_size,:address,:city,:postal_code,:phone,:extension,:fax,:website, :cause_id)
    end

    def require_login
        redirect_to new_user_path if !logged_in?
    end

end
