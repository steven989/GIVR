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

      @projects = Project.all.order(created_at: :desc).page(params[:page])

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
    @project = Project.new(projects_params)

    if @projects.save
      redirect_to projects_url
    else
      render :new
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
    params.require(:project).permit(:name, :description)
  end
end