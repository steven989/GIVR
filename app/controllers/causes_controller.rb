class CausesController < ApplicationController
    def new
        @cause = Cause.new
       
        if request.xhr?
          render partial: 'form'
        end        
    end

    def create
        @cause = Cause.new(cause_params)
        @cause.save
        message = @cause.errors.full_messages.join(' ')
        message = "Cause successfully created." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end   
    end

    def edit
        @cause = Cause.find_by(id: params[:id])
        
        if request.xhr?
          render partial: 'form'
        end
    end

    def update
        @cause = Cause.find_by(id: params[:id])
        @cause.update_attributes(cause_params)
        message = @cause.errors.full_messages.join(' ')
        message = "Cause successfully updated." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end
    end

    def destroy
        @cause = Cause.find_by(id: params[:id])
        @cause.destroy
        message = "Cause successfully deleted."

        respond_to do |format|
          format.html {redirect_to user_profile_path, notice: message}
          format.json {render json: {message: message}}
        end
    end

    private

    def cause_params
        params.require(:cause).permit(:cause,:description)
    end
end
