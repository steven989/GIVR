class ProjectViewsController < ApplicationController
    def update
        @view = ProjectView.find_by(id: params[:id])
        @view.update_attribute(:view_end_time, Time.now)
        respond_to do |format|
            format.json { render json: {message: 'project view is closed'}}
        end
    end
end
