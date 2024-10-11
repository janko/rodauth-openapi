module Rodauth
  class OpenAPI
    Routes.define :create_account, "Create Account" do
      get :create_account, "View registration page" do
        html_response "registration form"
      end

      post :create_account, "Perform registration" do
        param :login, "Email address for the account", type: :email, required: true
        param :login_confirm, "Email address confirmation", type: :email, required: true if rodauth.require_login_confirmation?
        param :password, "Password to set", type: :password, required: true if rodauth.create_account_set_password?
        param :password_confirm, "Password confirmation", type: :password, required: true if rodauth.create_account_set_password? && rodauth.require_password_confirmation?

        success_response "successful registration"
        error_response :invalid_field, "invalid login"
        error_response :unmatched_field, "logins do not match" if rodauth.require_login_confirmation?
        error_response :invalid_field, "invalid password" if rodauth.create_account_set_password?
        error_response :unmatched_field, "passwords do not match" if rodauth.create_account_set_password? && rodauth.require_password_confirmation?
      end
    end
  end
end
