class Api::V1::SocialLoginController < Api::V1::BaseController

    before_action :ensure_email_exists

    def check
        email = params[:email]

        resp = User.exists?(email: email)
       if resp
        return present
       else
        return absent
       end
    end


    def ensure_email_exists
		ensure_param_exists :email
    end
    
    def present
        render json: { success: true}
    end 
    def absent
        render json: { success: false}
    end 


    


private
    def ensure_param_exists(param)
		return unless params[param].blank?
		render json:{ error: 
					{success: false, message: "Missing #{param} parameter"}
			}, status: :unprocessable_entity
	end
    
end