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
        if params[:user] && params[:resume_action] == 'upload'
            @user.update_attribute(:resume, params[:user][:resume])
            message = "Resume could not be saved. #{@user.errors.full_messages.join(" ")}" if @user.errors.any?
        elsif params[:resume_action] == 'remove'
            @user.remove_resume!
            @user.save  
        end

        respond_to do |format|
            format.html {redirect_to user_profile_path, notice: message}
            format.json {   self.formats = ['html']
              render json: { 
                  replaceWith: render_to_string(partial: 'users/resume_upload', layout: false, locals: {user: @user}),
                  message: message
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
            @number_ccompleted_applications = @completed_applications.length
            @points = current_user.points
        end
    # a series of variables for displaying charts. Output are in the form of array of arrays
        #npos
        @average_view_per_project_by_week = ProjectView.find_by_sql(["SELECT a.week_num, avg(a.views) as avg_views FROM (SELECT date_trunc('week', a.view_start_time)::date || ' to ' || (date_trunc('week', a.view_start_time)::date + '6 days'::interval)::date as week_num, a.project_id, count(a.*) as views FROM project_views a LEFT JOIN projects b ON a.project_id = b.id WHERE b.user_id = ? GROUP BY week_num, project_id) a GROUP BY a.week_num ORDER BY substring(a.week_num from 1 for 10)::date ASC",current_user.id]).map {|week| [week.week_num, week.avg_views.round(2)]}
        @average_view_time_by_week = ProjectView.find_by_sql(["SELECT date_trunc('week', a.view_start_time)::date || ' to ' || (date_trunc('week', a.view_start_time)::date + '6 days'::interval)::date as week_num,avg(a.view_end_time - a.view_start_time) as view_time FROM project_views a LEFT JOIN projects b on a.project_id = b.id WHERE b.user_id = ? GROUP BY week_num ORDER BY substring((date_trunc('week', a.view_start_time)::date || ' to ' || (date_trunc('week', a.view_start_time)::date + '6 days'::interval)::date) from 1 for 10)::date ASC",current_user.id]).map {|week| [week.week_num, (Time.parse(week.view_time).hour*3600 + Time.parse(week.view_time).min*60 + Time.parse(week.view_time).sec)]}
        
        arrayOfDates = 4.times.map {|subtract| Time.now - (subtract*7.days)}

        project_views = Hash.new([])
        User.first.submitted_projects.each { |project|
            project_views['hi'].push(2)
        }

            # arrayOfDates.map {|date| 
            #     [project.id, (date.at_beginning_of_week.strftime('%Y-%m-%d').to_s)+' to '+((date.at_beginning_of_week+6.days).strftime('%Y-%m-%d').to_s), 2]
            #     # ProjectView.find_by_sql(["SELECT date_trunc('week', a.view_start_time)::date || ' to ' || (date_trunc('week', a.view_start_time)::date + '6 days'::interval)::date as week_num, count(a.*) as views FROM project_views a WHERE a.project_id = ? AND a.view_start_time between date_trunc('week', ?::date)::date and (date_trunc('week', ?::date)::date + '6 days'::interval)::date GROUP BY week_num",project.id,date.to_date,date.to_date]).map {|week| [project.id,(date.at_beginning_of_week.strftime('%Y-%m-%d').to_s)+' to '+((date.at_beginning_of_week+6.days).strftime('%Y-%m-%d').to_s), week.views]}
            # }

       
    end 

    private

    def users_params
        params.require(:user).permit(:email,:password,:password_confirmation,:role,:resume)
    end 

    def require_login
        redirect_to new_user_path if !logged_in?
    end

end
