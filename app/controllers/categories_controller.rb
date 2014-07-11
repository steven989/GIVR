class CategoriesController < ApplicationController

    def new
        @category = Category.new
       
        if request.xhr?
          render partial: 'form'
        end        
    end

    def create
        @category = Category.new(category_params)
        @category.save
        message = @category.errors.full_messages.join(' ')
        message = "Category successfully created." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end   
    end

    def edit
        @category = Category.find_by(id: params[:id])
        
        if request.xhr?
          render partial: 'form'
        end
    end

    def update
        @category = Category.find_by(id: params[:id])
        @category.update_attributes(category_params)
        message = @category.errors.full_messages.join(' ')
        message = "Category successfully updated." if message.blank?
        respond_to do |format|
          format.json {
            render json: {message: message}
          }
        end
    end

    def destroy
        @category = Category.find_by(id: params[:id])
        @category.destroy
        message = "Category successfully deleted."

        respond_to do |format|
          format.html {redirect_to user_profile_path, notice: message}
          format.json {render json: {message: message}}
        end
    end

    private

    def category_params
        params.require(:category).permit(:category,:description)
    end

end
