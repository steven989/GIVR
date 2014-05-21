class ApplicationsController < ApplicationController

  authorize_resource
  skip_authorize_resource only: :user_index

  def create

    @project = Project.find_by(id: params[:project_id])
    if params[:todo] == 'apply'
      @application = @project.applications.new(user_id: current_user.id)
      success_message = 'Application successful!'
      fail_message = "Application could not be completed."
      status = params[:todo]
    elsif params[:todo] == 'shortlist'
      @application = @project.applications.new(user_id: current_user.id)
      success_message = 'Project successfully shortlisted!'
      fail_message = 'Project could not be shortlisted.'
      status = params[:todo]
    else
      redirect_to projects_path, notice: 'Uh oh, something went wrong.'
    end

    respond_to do |format|
      if @application.save
         @application.statuses= status
        if params[:todo] == 'apply'
          UserMailer.applied_to_project(@project.user).deliver
        end
          format.json {render json: {message: success_message}}
      else
        fail_message += " #{@application.errors.full_messages.join(' ')}"
        format.json {render json: {message: fail_message}}
      end 
    end 
  end 

    def update

    end 

    def applicant_update

      @application = Application.find_by(id: params[:id])
      if params[:todo] == 'engage'
          @application.statuses= params[:todo]
          @application.project.attempt_close
      elsif params[:todo] == 'apply'
          @application.cannot_apply_to_filled_projects  #call the custom validation
          @application.professional_cannot_apply_twice_to_same_project #call the custom validation
          unless @application.errors.any? 
            @application.statuses= params[:todo]
            UserMailer.applied_to_project(@application.project.user).deliver
          end
      end 
      @role = current_user.role
      respond_to do |format|
        format.html {redirect_to user_profile_path}
        format.json {   self.formats = ['html']
              render json: { 
                  replaceWith: render_to_string(partial: 'applications/application', layout: false, object: @application, locals: {role: @role}),
                  alertMessage: @application.errors.full_messages.join(' ')
                      } 
          }
        end

    end

    def project_creator_update

      @application = Application.find_by(id: params[:id])
      if params[:todo] == 'approve'
          @application.statuses= params[:todo]
          UserMailer.project_approved(@application.user).deliver
      elsif params[:todo] == 'unapprove'
          @application.statuses= 'apply'
      elsif params[:todo] == 'complete'
          @application.statuses= params[:todo]
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
