class ProjectsController < ApplicationController

  before_filter authorize_resource

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
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

  def user_index
    
  end 

  private
  def projects_params
    params.require(:project).permit(:name, :description)
  end
end