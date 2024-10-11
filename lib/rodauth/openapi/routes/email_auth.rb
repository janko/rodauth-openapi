module Rodauth
  class OpenAPI
    Routes.define :email_auth, "Email Authentication" do
      post :email_auth_request, "Perform email authentication request" do
        param :login, "Email address for the account", type: :email, required: true

        success_response "successfully sent email authentication email"
        redirect_error_response :no_matching_login, "no matching login"
        redirect_error_response "email recently sent"
      end

      get :email_auth, "View email authentication page" do
        param :email_auth_key, "Email authentication token", type: :token, required: true

        response 302, "token stored in session"
        html_response "email authentication form"
        redirect_error_response "invalid email authentication key"
      end

      post :email_auth, "Perform email authentication" do
        param :email_auth_key, "Email authentication token", type: :token, required: json

        success_response "successful email authentication"
        redirect_error_response :invalid_key, "invalid email authentication key"
      end
    end
  end
end
