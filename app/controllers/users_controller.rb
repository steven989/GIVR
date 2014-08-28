class UsersController < ApplicationController

    before_filter :require_login
    skip_before_filter :require_login, only: [:new, :create, :organization_profile]

    def new
        @user = User.new
    end 

    def create
        @user = User.new(users_params)
        redirect=params[:redirect]
        if @user.save
            # Tell the UserMailer to send a welcome email after save.
            UserMailer.welcome_email(@user).deliver
            auto_login(@user)
            if redirect == ""
                redirect_back_or_to projects_path, notice: 'Login successful'
            else
                redirect_to redirect, notice: 'Login successful'
            end
        else 
            flash[:signup_error] = "Sign up could not be completd. #{@user.errors.full_messages.join(". ")}"
            if redirect == ""
                redirect_back_or_to projects_path+'#showLogin/signup', notice: 'Login successful'
            else
                redirect_to redirect+'#showLogin/signup', notice: 'Login successful'
            end
        end 
    end 

    def edit
        if current_user.is? 'admin'
            @user = User.find_by(id: params[:id])
            if request.xhr?
              render partial: 'form'
            end
        end
    end

    def update
        @user = current_user
        if @user.is? 'professional'
            if @user.update_attributes(professional_params)
                Company.add(params[:user][:org_name])
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
            redirect_to user_profile_path+'#settings', notice: message
        elsif @user.is? 'npo'
            if @user.update_attributes(npo_params)
                message = 'Information successfully updated.'                
            else
                message = 'Information could not be updated.'+@user.errors.full_messages.join(" ")                
            end
            redirect_to user_profile_path+'#settings', notice: message
        elsif @user.is? 'admin'
            @modify_user = User.find_by(id:params[:id])
            @modify_user.update_attributes(admin_params)
            message = @modify_user.errors.full_messages.join(" ")
            message = "User successfully updated." if message.blank?

            respond_to do |format|
              format.json {
                render json: {message: message}
              }
            end
        end

        
    end

    def update_role
        @user = current_user
        if params[:user]
        @user.update_attribute(:role, params[:user][:role])
        flash[:notice] = 'Your role has been successfully set!'
        else
        flash[:notice] = 'Please set a role'
        end
        redirect_to user_profile_path+"#_summary"
    end

    def upload_resume
        if current_user.is? 'admin' 
            @user = User.find_by(id:params[:id]) 
        else
            @user = current_user
        end
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
        if current_user.is? 'admin' 
            @user = User.find_by(id:params[:id]) 
        else
            @user = current_user
        end
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

    def organization_profile
        @user = User.new #this is because we are pulling the login form in this view as well    
        @npo = User.find_by_id(params[:id])
        @email = @npo.email
        @mission = @npo.mission
        @cause = @npo.cause.cause
        @description = @npo.description
        @city = @npo.city
        @website = @npo.website
        @size = @npo.organization_size
        @projects = @npo.submitted_projects.where("projects.status like 'on market' and (projects.hide_name not like '1' or projects.hide_name is null)").order(approval_date: :desc).take(4)
    end

    def profile
        @abridged_menu = true   #this is so that the drop down menu only says logout
        @project_edit = true    #this is so that links to modifying and deleting projects show up
        @user = current_user
        @role = current_user.role
        if @role == 'npo'
            @projects = current_user.submitted_projects.order('created_at DESC') #need to update
            @applicationss = current_user.applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('apply','view','approve')")
            @in_progress_applications = current_user.applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('engage')")
            @completed_applications = current_user.applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('complete')")
            @active_project_count = current_user.submitted_projects.where("projects.status like 'on market'").length
            @active_application_count = current_user.applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('apply','view','approve')").length
            @in_progress_count = @in_progress_applications.length
            @completed_count = @completed_applications.length
            @hours_given = current_user.applications.sum('hours')
            
        elsif @role == 'professional'
            @company_names = Company.order("company_name ASC").map do |company| company.company_name end.to_json
            @applicationss = current_user.made_applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('save','apply','view','approve') or (applications.status like 'decline' and applications.unapproved_status_view_date >= ?::date)", 3.days.ago)
            @shortlists = current_user.made_applications.order('created_at DESC').where("applications.status in ('shortlist')").map {|application| application.project}
            @completed_applications = current_user.made_applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('complete')")
            @projects = @completed_applications.map {|application| application.project}
            @in_progress_applications = current_user.made_applications.order('COALESCE(applications.application_date, applications.created_at ) DESC').where("applications.status in ('engage')")
            @active_application_count = current_user.made_applications.where("applications.status in ('apply','view','approve')").length
            @in_progress_count = @in_progress_applications.length
            @number_completed_applications = @completed_applications.length
            @hours_earned = @completed_applications.sum('hours')
        elsif @role == 'admin'
            @projects = Project.all.order('created_at DESC')
                @project_count = Project.count
                @project_count_active = Project.count('on market')
                @project_count_under_review = Project.count('under review')
            @applicationss = Application.all.order('created_at DESC')
                @application_count = Application.count
                @application_count_shortlist = Application.count('shortlist')
                @application_count_apply = Application.count('apply')
                @application_count_approve = Application.count('approve')
                @application_count_decline = Application.count('decline')
                @application_count_engage = Application.count('engage')
                @application_count_complete = Application.count('complete')
            @categories = Category.all
            @causes = Cause.all
            @locations = Location.all
            @users = User.all.order('created_at DESC')
                @user_count = User.count
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

    def destroy
        if current_user.is? 'admin' 
            @user = User.find_by(id:params[:id]) 
        else
            @user = current_user
        end
        @user.destroy
        message = "User successfully deleted."

        respond_to do |format|
          format.html {redirect_to projects_path, notice: message}
          format.json {render json: {message: message}}
        end
    end


    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:resume)
    end 

    def admin_params
        params.require(:user).permit(:email,:role,:org_name,:address,:city,:postal_code,:website,:contact_first_name,:contact_last_name,:phone,:extension,:fax,:years_of_experience,:organization_size,:description,:mission)
    end

    def professional_params
        params.require(:user).permit(:email,:contact_first_name,:contact_last_name,:phone,:years_of_experience,:website, :org_name, :employee_id)
    end

    def npo_params
        params.require(:user).permit(:email,:org_name,:mission,:contact_first_name,:contact_last_name,:organization_size,:address,:city,:postal_code,:phone,:extension,:fax,:website, :cause_id, :description)
    end

    def require_login
        redirect_to projects_path+"#showLogin/login" if !logged_in?
    end

end
