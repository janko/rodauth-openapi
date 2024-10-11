module Rodauth
  class OpenAPI
    Routes.define :change_login, "Change Login" do
      get :change_login, "View login change page" do
        redirect_error_response :login_required, "login required"

        html_response "login change form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end

      post :change_login, "Perform login change" do
        param :password, "Current account password", type: :password, required: true if rodauth.change_login_requires_password?
        param :login, "Email to set", type: :email, required: true
        param :login_confirm, "Email confirmation", type: :email, required: true if rodauth.require_login_confirmation?

        error_response :invalid_password, "invalid password" if rodauth.change_login_requires_password?
        error_response :invalid_field, "login does not meet requirements"
        error_response :unmatched_field, "logins do not match" if rodauth.require_login_confirmation?
        error_response :invalid_field, "same as current login"
        error_response :invalid_field, "already an account with this login"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end
    end
  end
end
