class ApplicationsController < ApplicationController

    authorize_resource
    skip_authorize_resource only: :user_index

    def create

        @project = Project.find_by(id: params[:project_id])

        if params[:todo] == 'apply'

            @project.applications.new(user_id: current_user.id, status: params[:todo])
            success_message = 'Application successful!'
            fail_message = 'Application could not be completed.'

        elsif params[:todo] == 'shortlist'

            @project.applications.new(user_id: current_user.id, status: params[:todo])
            success_message = 'Project successfully shortlisted!'
            fail_message = 'Project could not be shortlisted.'

        else

            redirect_to projects_path, notice: 'Uh oh, something went wrong.'

        end

        if @project.save
            redirect_to projects_path, notice: success_message
        else 
            redirect_to projects_path, notice: fail_message
        end 

    end 

    def destroy
        
    end

    def user_index

        @role = current_user.role

      if @role == 'npo'
        @applications = current_user.project_applications
      elsif @role == 'professional'
        @applications = current_user.applications.where(status: 'apply')
      end

      respond_to do |format|

          format.js 

      end


    end 


end
