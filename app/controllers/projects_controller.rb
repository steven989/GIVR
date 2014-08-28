class ProjectsController < ApplicationController

  authorize_resource
  skip_authorize_resource only: :user_index

  def index
    @user = User.new #this is because we are pulling the login form in this view as well
    @redirect_path = projects_path
    if params[:_json] #this is for the filtering
      filter_conditions = Hash.new { |this_hash, nonexistent_key| this_hash[nonexistent_key] = [] }  #this is the code to actually allow us to use << to assign into the arrays that are default value of the non-existent hash key
      params[:_json].each do |filter|        
        filter_type = filter['filtertype'].to_sym
        filter_id = filter['filterid']
      filter_conditions[filter_type] << filter_id
    end
      @projects = Project.where("category_id in (?) AND cause_id in (?) AND location_id in (?) AND status like 'on market'", filter_conditions[:category], filter_conditions[:cause], filter_conditions[:location]).order(approval_date: :desc).page(params[:page])
    else 
      if current_user #this section basically identifies if any of the filter is empty from the user profile, and if empty take ALL the values
        @user_categories = current_user.categories.inject([]) { |array,category| array.push(category.id) }.blank? ? Category.all.map {|category| category.id} : current_user.categories.inject([]) { |array,category| array.push(category.id) } 
        @user_causes = current_user.causes.inject([]) { |array,cause| array.push(cause.id) }.blank? ? Cause.all.map {|cause| cause.id} : current_user.causes.inject([]) { |array,cause| array.push(cause.id) }
        @user_locations = current_user.locations.inject([]) { |array,location| array.push(location.id) }.blank? ? Location.all.map {|location| location.id} : current_user.locations.inject([]) { |array,location| array.push(location.id) }
        @projects = Project.where("category_id in (?) AND cause_id in (?) AND location_id in (?) AND status like 'on market'", @user_categories, @user_causes, @user_locations).order(approval_date: :desc).page(params[:page])
     else
        @projects = Project.where("status like 'on market'").order(approval_date: :desc).page(params[:page])
      end
    end

    @categories = Category.order(category: :asc).select {|category| category.projects.where("projects.status like 'on market'").length > 0 }
    @causes = Cause.order(cause: :asc).select {|cause| cause.projects.where("projects.status like 'on market'").length > 0 }
    @locations = Location.order(location: :asc).select {|location| location.projects.where("projects.status like 'on market'").length > 0 }

    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    user_id = current_user ? current_user.id : nil
    @project = Project.find(params[:id])
    @view = @project.views.new(user_id: user_id, view_start_time: Time.now, browser: params[:browser_info], ip_address: request.remote_ip)
    @view.save # this is to track the project views
    
    if logged_in?
      @application = @project.applications.where("applications.user_id = ?",current_user.id).take # try to find existing application
      @application ||= @project.applications.new #if no currenta application exist, create a new one
    else
      @application = @project.applications.new
    end

    respond_to do |format|
      format.html {
        render partial: 'popup_project_no_buttons'
      }
      format.js
    end
  end

  def show_html
    @user = User.new #this is because we are pulling the login form in this view as well
    user_id = current_user ? current_user.id : nil
    @project = Project.find(params[:id])
    @view = @project.views.new(user_id: user_id, view_start_time: Time.now, browser: params[:browser_info], ip_address: request.remote_ip)
    @view.save # this is to track the project views
    @just_project = true #this is so that when loading the project details only loading the top portion (the bottom portion is the application form)
    @redirect_path = show_html_project_path(@project)
  end

  def load_application
    @project = Project.find(params[:id])
    @just_app_form = true #this is so that when loading the project details only loading the bottom portion (the bottom portion is the application form)
    
    if logged_in?
      @application = @project.applications.where("applications.user_id = ?",current_user.id).take # try to find existing application
      @application ||= @project.applications.new #if no currenta application exist, create a new one
    else
      @application = @project.applications.new
    end    
    
    if request.xhr?
      render partial: "load_application"
    end
  end



  def new
    @project = Project.new

    if request.xhr?
      render partial: 'form'
    end
  end

  def create
    @project = Project.new(projects_params)

    respond_to do |format|
      if params[:todo] == 'save_progress'
        @project.save(validate:false)
        @project.statuses= 'saved'
        @project.update_attribute(:user_id,current_user.id)
        message = "Your work-in-progress has been saved - you can come back at any time to complete the form. You can find your saved projects under \"My projects\" tab."
        format.html {redirect_to user_profile_path+'#add-new', notice: message}
        format.json {render json: {message: message, successFlag: 1}}
      else
        if @project.save
          message = "Your project has been submitted for review. You can see the status of your project under \"My Projects\" tab."
          @project.statuses= 'under review'
          if current_user.is? ('admin')
            @project.update_attribute(:user_id,params[:project][:user_id])
          else
            @project.update_attribute(:user_id,current_user.id)
          end
          format.html {redirect_to user_profile_path+'#add-new', notice: message}
          format.json {render json: {message: message, successFlag: 1}}
        else
          message = "Project could not be submitted. One or more fields are missing."
          format.html {redirect_to user_profile_path+'#add-new', notice: message}
          format.json {render json: {message: message, successFlag: 0}}
        end
      end
    end
  end

  def edit
    @project = Project.find(params[:id])

    if request.xhr?
      @edit_project_flag = true
      @popup = true
      render partial: 'form'
    end
  end

  def admin_update
    @project = Project.find(params[:id])
    if @project.status == 'under review'
      @project.statuses = 'on market'
      @project.update_attribute(:approval_date, DateTime.now)
      Project.marketplace_status_update
      UserMailer.project_submission_approved(@project).deliver
    else
      @project.statuses = 'under review'
    end
    redirect_to user_profile_path
  end

  def update

    @project = Project.find(params[:id])

    if params[:todo] == 'save_progress'
      @project.assign_attributes(projects_params)
      @project.save(validate:false)
    else
      @project.update_attributes(projects_params)
    end

    if current_user.is? ('admin')
      @project.update_attribute(:user_id,params[:project][:user_id])
    else
      @project.update_attribute(:user_id,current_user.id)
    end
    
    if @project.errors.any?
      message = @project.errors.full_messages.join(" ")
      successFlag = 0
    else
      if params[:todo] == 'save_progress'
        message = "Project saved. It has not yet been submitted for review."
      elsif params[:todo] == 'submit'
        @project.statuses= 'under review'
        message = "Project submitted for review. Please check this page to monitor the status."
      else
        message = "Project successfully updated."
      end
      successFlag = 1
    end

    respond_to do |format|
      format.json { self.formats = ['html']
        render json: {
          replaceWith: render_to_string(partial: 'projects/project', object: @project, locals: {loc: 'project'}),
          successFlag: successFlag,
          message: message
        }
      }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    message = "Project successfully deleted."

    respond_to do |format|
      format.html {redirect_to user_profile_path, notice: message}
      format.json {render json: {message: message}}
    end
  end


  private
  def projects_params
    params.require(:project).permit(:title,:description,:number_of_positions, :category_id, :cause_id,:location_id,:why_we_need_this,:deliverable,:overseer,:perks,:requirements, :hide_name, :how_output_will_be_used, :required_date)
  end
end