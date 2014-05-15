class ApplicationsController < ApplicationController

    authorize_resource
    skip_authorize_resource only: :user_index

    def create

        @project = Project.find_by(id: params[:project_id])

        if params[:todo] == 'apply'

            @application = @project.applications.new(user_id: current_user.id, statuses: params[:todo])
            success_message = 'Application successful!'
            fail_message = 'Application could not be completed.'

        elsif params[:todo] == 'shortlist'

            @application = @project.applications.new(user_id: current_user.id, statuses: params[:todo])
            success_message = 'Project successfully shortlisted!'
            fail_message = 'Project could not be shortlisted.'

        else

            redirect_to projects_path, notice: 'Uh oh, something went wrong.'

        end

        respond_to do |format|

            if @application.save
                format.json {render json: {message: success_message}}
            else
                format.json {render json: {message: fail_message}}
            end 

        end 

    end 

    def update


    end 

    def project_creator_update

        @application = Application.find_by(id: params[:id])

        if params[:todo] == 'approve'
            @application.statuses= params[:todo]
        elsif params[:todo] == 'unapprove'
            @application.statuses= 'apply'
        end 

    
        @role = current_user.role

        respond_to do |format|

            format.html {redirect_to user_profile_path}
            format.json {   self.formats = ['html']

                            render json: { 
                                replaceWith: render_to_string(partial: 'applications/application', layout: false, object: @application, locals: {role: @role})
                                    } 
                        }

        end



    end 

    def destroy
        
    end


end
