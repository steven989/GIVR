class PagesController < ApplicationController

    def index
        @user= User.new
        @list_id = ENV['MAILCHIMP_GIVINGLY_LIST_ID']
    end 

    def subscribe

        list_id = params[:id]
        email = params['email']
        role = params['role']
        category = params['category']
        source = params['source']
        notes = params['notes']

        if email.scan(/@[a-zA-Z]+?\.[a-zA-Z]{2,12}$/).length == 0
          message = "You must enter a valid email address"
        elsif role.blank?
          message = "Please indicate if you are a professional, non-profit, company, or other"
        else
          begin
            @mc.lists.subscribe(params[:id], {'email' => email}, {'USERROLE' => role, 'CATEGORY' => category, 'SOURCE' => source, 'NOTES' => notes})
            message = "#{email} subscribed successfully"
          rescue Mailchimp::ListAlreadySubscribedError
            message = "#{email} is already subscribed to the list"
          rescue Mailchimp::Error => ex
            if ex.message
              message = ex.message
            else
              message = "An unknown error occurred"
            end
          end
        end
        respond_to do |format|
            format.json {render json: {message: message}}
        end
    end
end
