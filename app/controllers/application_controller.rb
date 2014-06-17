require 'mailchimp'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :setup_mcapi

  protect_from_forgery with: :exception

    rescue_from CanCan::AccessDenied do |exception|

        redirect_to projects_path, notice: exception.message

    end

    def setup_mcapi
        @mc = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    end
  
end

