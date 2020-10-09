class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session  #pay.jpの402エラーを起こさなくなる
    before_action :authenticate_user!, except: [:start,:about]
    before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_in_path_for(resource)
        new_card_path
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email]) 
    end
end
