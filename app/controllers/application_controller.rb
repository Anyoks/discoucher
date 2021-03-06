  
class ApplicationController < ActionController::Base
  

  layout :layout_by_resource
  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception, if: :verify_api

  protect_from_forgery with: :null_session,
     if: Proc.new { |c| c.request.format =~ %r{application/json} }
  
  # before_action :authenticate_admin!
  before_action :configure_permitted_parameters, if: :devise_controller?	

  
  protected

  def verify_api
    params[:controller].split('/')[0] != 'devise_token_auth'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :phone_number])
	#devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
	devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :phone_number]) 
  end


  private

    def layout_by_resource
      # byebug
    	if devise_controller? && action_name == "new" #&& action_name == "edit"
    		"admin_lte_2_signup"
    	else
    		"admin_lte_2"
    	end
	end

	#****User sign_in / sign_out page redirects****************#
  def after_sign_in_path_for(resource)

    if current_admin.is_admin?
      session["user_return_to"] || "/vouchers" #user_index_path
    else
      "/establishments"
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    #byebug
        "/admins/sign_in"
  end
end
