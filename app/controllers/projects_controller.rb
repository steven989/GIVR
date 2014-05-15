class ProjectsController < ApplicationController

  authorize_resource
  skip_authorize_resource only: :user_index

  def index

    @projects = Project.all.order(created_at: :desc).page(params[:page])

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