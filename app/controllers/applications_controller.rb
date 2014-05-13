class ApplicationsController < ApplicationController

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

end
