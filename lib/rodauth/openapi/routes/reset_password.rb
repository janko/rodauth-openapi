module Rodauth
  class OpenAPI
    Routes.define :reset_password, "Reset Password" do
      get :reset_password_request, "View password reset request page" do
        html_response "password reset request form"
      end

      post :reset_password_request, "Perform password reset request" do
        param :login, "Email address for the account", type: :email, required: true

        success_response "successfully sent reset password email"
        error_response :no_matching_login, "no matching login"
        error_response :unopen_account, "unverified account"
        redirect_error_response "email recently sent"
      end

      get :reset_password, "View password reset page" do
        param :reset_password_key, "Password reset token", type: :token, required: true

        response 302, "token stored in session"
        html_response "password reset form"
        redirect_error_response "invalid or expired password reset key"
      end

      post :reset_password, "Perform password reset" do
        param :reset_password_key, "Password reset token", type: :token, required: json

        success_response "successfully reset password"
        redirect_error_response :invalid_key, "invalid or expired password reset key"
        error_response :invalid_field, "invalid password"
        error_response :invalid_field, "same as existing password"
        error_response :unmatched_field, "passwords do no match" if rodauth.require_password_confirmation?
      end
    end
  end
end
