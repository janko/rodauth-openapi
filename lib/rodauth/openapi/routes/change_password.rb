module Rodauth
  class OpenAPI
    Routes.define :change_password, "Change Password" do
      get :change_password, "View change password page" do
        html_response "change password form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end

      post :change_password, "Perform password change" do
        param :password, "Current account password", type: :password, example: "oldsecret123", required: true if rodauth.change_password_requires_password?
        param :new_password, "Password to set", type: :password, example: "newsecret123", required: true
        param :password_confirm, "Password confirmation", type: :password, example: "newsecret123", required: true if rodauth.require_password_confirmation?

        success_response "successful password change"
        error_response :invalid_password, "invalid previous password" if rodauth.change_password_requires_password?
        error_response :invalid_field, "same as existing password"
        error_response :invalid_field, "invalid password"
        error_response :unmatched_field, "passwords do not match" if rodauth.require_password_confirmation?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end
    end
  end
end
