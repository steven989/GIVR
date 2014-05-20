class ProjectsController < ApplicationController

  authorize_resource
  skip_authorize_resource only: :user_index

  def index

    if params[:_json] #this is for the filtering
      filter_conditions = Hash.new { |this_hash, nonexistent_key| this_hash[nonexistent_key] = [] }  #this is the code to actually allow us to use << to assign into the arrays that are default value of the non-existent hash key
      params[:_json].each do |filter|        
        filter_type = filter['filtertype'].to_sym
        filter_id = filter['filterid']
      filter_conditions[filter_type] << filter_id
    end
      @projects = Project.where("category_id in (?) AND cause_id in (?) AND location_id in (?)", filter_conditions[:category], filter_conditions[:cause], filter_conditions[:location]).order(created_at: :desc).page(params[:page])
    else 
      if current_user #this section basically identifies if any of the filter is empty from the user profile, and if empty take ALL the values
        @user_categories = current_user.categories.inject([]) { |array,category| array.push(category.id) }.blank? ? Category.all.map {|category| category.id} : current_user.categories.inject([]) { |array,category| array.push(category.id) } 
        @user_causes = current_user.causes.inject([]) { |array,cause| array.push(cause.id) }.blank? ? Cause.all.map {|cause| cause.id} : current_user.causes.inject([]) { |array,cause| array.push(cause.id) }
        @user_locations = current_user.locations.inject([]) { |array,location| array.push(location.id) }.blank? ? Location.all.map {|location| location.id} : current_user.locations.inject([]) { |array,location| array.push(location.id) }
        @projects = Project.where("category_id in (?) AND cause_id in (?) AND location_id in (?)", @user_categories, @user_causes, @user_locations).order(created_at: :desc).page(params[:page])
     else
        @projects = Project.all.order(created_at: :desc).page(params[:page])
      end
    end

    @categories = Category.all.order(category: :asc)
    @causes = Cause.all.order(cause: :asc)
    @locations = Location.all.order(location: :asc)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @project = Project.new
  end

  def create

    params[:project][:statuses] = 'active'
    @project = Project.new(projects_params)

    respond_to do |format|
      if @project.save
        format.js { render :js => 'alert("Your project was saved!")'}
        format.html
      else

        format.js 
        format.html {render :new}
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end


  private
  def projects_params
    params.require(:project).permit(:title,:description,:statuses)
  end
end