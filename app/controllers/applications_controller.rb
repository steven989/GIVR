class ApplicationsController < ApplicationController

  authorize_resource
  skip_authorize_resource only: :user_index

  def show
    @application = Application.find_by(id: params[:id])
    @application.statuses = 'view' if (current_user.is? 'npo') && (@application.status == 'apply')

    if request.xhr?
      render partial: 'show_application'
    end    
  end

  def create

    @project = Project.find_by(id: params[:project_id])
    @application = @project.applications.new(user_id: current_user.id, message: params[:message])
    if params[:todo] == 'apply' 
      success_message = 'Application successful!'
      fail_message = "Application could not be completed."
      status = params[:todo]
    elsif params[:todo] == 'shortlist'
      success_message = 'Project successfully shortlisted!'
      fail_message = 'Project could not be shortlisted.'
      status = params[:todo]
    else
      redirect_to projects_path, notice: 'Uh oh, something went wrong.'
    end

    respond_to do |format|
      if status == 'shortlist'
        @application.cannot_shortlist_more_than_once 
      elsif status == 'apply'
        @application.must_include_message 
        @application.professional_cannot_apply_twice_to_same_project
        @application.cannot_apply_to_filled_projects
      end
      if !@application.errors.any? && @application.valid?
         @application.save
         @application.statuses= status
         if status == 'apply'
            @application.update_attribute(:notification_view_flag, 'npo')  # this sets up the pop up notification for npo (because a user just applied, we want the pop up to show up on npo's screen)
            UserMailer.applied_to_project(@project.user).deliver
         end
         format.json {render json: {
            message: success_message,
            alertMessage: "",
            successFlag: 1
            }
          }
      else
        fail_message += " #{@application.errors.full_messages.join(' ')}"
        format.json {render json: {
          message: fail_message,
          alertMessage: "",
          successFlag: 0
          }
        }
      end 
    end 
  end 

    def edit
      @application = Application.find_by(id: params[:id])

      if request.xhr?
        render partial: 'form'
      end
    end

    def user_edit
      @application = Application.find_by(id: params[:id])

      if request.xhr?
        render partial: 'user_form'
      end
    end

    def update
      @application = Application.find_by(id: params[:id])
      @application.attributes = application_params
      @application.save validate: false
      message = @application.errors.full_messages.join(' ')
      message = "Application successfully updated." if message.blank?
      respond_to do |format|
        format.json {
          render json: {message: message}
        }
      end
    end 

    def applicant_update

      @application = Application.find_by(id: params[:id])
      if params[:todo] == 'engage'
          @application.statuses= params[:todo]
          @application.project.attempt_close  # this will check to see if a project is filled and update a project's status accordingly if filled
          @application.update_attribute(:notification_view_flag, 'npo')  # this sets up the pop up notification for npo (because a user just accepted the project, we want the pop up to show up on npo's screen)
          successFlag = 1
      elsif params[:todo] == 'apply'
          @application.cannot_apply_to_filled_projects  #call the custom validation
          @application.professional_cannot_apply_twice_to_same_project #call the custom validation
          @application.must_include_message #call the custom validation
          unless @application.errors.any?
            @application.update_attribute(:message, params[:message]) 
            @application.statuses= params[:todo]
            @application.update_attribute(:notification_view_flag, 'npo')  # this sets up the pop up notification for npo (because a user just applied, we want the pop up to show up on npo's screen)
            unless @application.errors.any?
              message = "Application successful!"
              successFlag = 1
              UserMailer.applied_to_project(@application.project.user).deliver
            end
          end
      elsif params[:todo] == 'update_info'
          @application.update_attribute(:message, params[:application][:message]) 
          unless @application.errors.any?
            message = "Message updated."
            successFlag = 1
          end
      end 
      @role = current_user.role
      respond_to do |format|
        format.html {redirect_to user_profile_path}
        format.json {   self.formats = ['html']
              render json: { 
                  replaceWith: render_to_string(partial: 'applications/application', layout: false, object: @application, locals: {role: @role}),
                  message: message ||= "Application could not be completed.",
                  alertMessage: @application.errors.full_messages.join(' '),
                  successFlag: successFlag ||= 0
                      } 
          }
        end

    end

    def project_creator_update
      @application = Application.find_by(id: params[:id])
      if params[:todo] == 'approve'
          @application.statuses= params[:todo]
          @application.update_attribute(:notification_view_flag, 'professional')  # this sets up the pop up notification for the professional (because an npo just approved the application, we want the pop up to show up on the applicant's screen)
          UserMailer.project_approved(@application.user).deliver
      elsif params[:todo] == 'decline'
          @application.statuses= 'decline'
          @application.update_attribute(:notification_view_flag, 'professional')  # this sets up the pop up notification for the professional (because an npo just unapproved the application, we want the pop up to show up on the applicant's screen)
      elsif params[:todo] == 'complete'
          @application.update_attributes(complete_application_params)
          @application.statuses= params[:todo]
          message = @application.errors.full_messages.join(" ")
          successFlag = 1 if message.blank?
          message = "Application completed!" if message.blank?
      elsif params[:todo] == 'update_info'
          @application.update_attributes(complete_application_params)
          unless @application.errors.any?
            message = "Information updated."
            successFlag = 1
          end
      end
      @role = current_user.role
      respond_to do |format|
        format.html {redirect_to user_profile_path}
        format.json {   self.formats = ['html']
              render json: {
                  successFlag: successFlag,
                  message: message||= "Could not be updated.", 
                  replaceWith: render_to_string(partial: 'applications/application', layout: false, object: @application, locals: {role: @role})
                      } 
          }
        end
    end 

    def complete
      @application = Application.find_by(id: params[:id])

      if request.xhr?
        render partial: 'complete_application'
      end
    end

    def read
      @user = current_user
      @role = current_user.role
      if @role == 'npo'
          @applications = current_user.applications.order('created_at ASC').where("applications.status not like 'shortlist'")
      elsif @role == 'professional'
          @applications = current_user.made_applications.order('created_at ASC').where("applications.status in ('apply','approve', 'decline', 'engage')")
      end 
      @applications.where("notification_view_flag like ?", current_user.role).each {|application| application.update_attribute(:notification_view_flag, nil)}

      respond_to do |format|
        format.json { render json: {message: 'All notifications are off.'}}
      end
    end

    def destroy
        @application = Application.find_by(id: params[:id])
        @application.destroy
        message = "Application successfully deleted."

        respond_to do |format|
          format.html {redirect_to user_profile_path, notice: message}
          format.json {render json: {message: message}}
        end
    end

    private

    def application_params
      params.require(:application).permit(:project_id,:user_id,:status,:notification_view_flag,:message)
    end

    def complete_application_params
      params.require(:application).permit(:hours,:rating_for_professional,:work_again,:comments_for_professional)
    end
end
