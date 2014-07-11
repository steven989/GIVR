class LocationsController < ApplicationController
    def new
        @location = Location.new
       
        if request.xhr?
          render partial: 'form'
        end        
    end

    def create
        @location = Location.new(location_params)
        @location.save
        message = @location.errors.full_messages.join(' ')
        message = "Location successfully created." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end   
    end

    def edit
        @location = Location.find_by(id: params[:id])
        
        if request.xhr?
          render partial: 'form'
        end
    end

    def update
        @location = Location.find_by(id: params[:id])
        @location.update_attributes(location_params)
        message = @location.errors.full_messages.join(' ')
        message = "Location successfully updated." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end
    end

    def destroy
        @location = Location.find_by(id: params[:id])
        @location.destroy
        message = "Location successfully deleted."

        respond_to do |format|
          format.html {redirect_to user_profile_path, notice: message}
          format.json {render json: {message: message}}
        end
    end

    private

    def location_params
        params.require(:location).permit(:location,:description)
    end
end
