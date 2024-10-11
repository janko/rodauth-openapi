module Rodauth
  class OpenAPI
    Routes.define :lockout, "Lockout" do
      post :unlock_account_request, "Perform account unlock request" do
        param :login, "Email address for the account", type: :email, required: true

        success_response "successfully sent unlock account email"
        error_response :no_matching_login, "no matching login"
        redirect_error_response "email recently sent"
      end

      get :unlock_account, "View account unlock page" do
        param :unlock_account_key, "Account unlock token", type: :token, required: true

        response 302, "token stored in session"
        html_response "account unlock form"
        redirect_error_response "invalid or expired unlock account key"
      end

      post :unlock_account, "Perform account unlock" do
        param :unlock_account_key, "Account unlock token", type: :token, required: json
        param :password, "Current account password", type: :password, required: true if rodauth.unlock_account_requires_password?

        success_response "account successfully unlocked"
        redirect_error_response :invalid_key, "invalid or expired unlock account key"
        error_response :invalid_password, "invalid password" if rodauth.unlock_account_requires_password?
      end
    end
  end
end
