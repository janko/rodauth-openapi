module Rodauth
  class OpenAPI
    Routes.define :verify_login_change, "Verify Login Change" do
      get :verify_login_change, "View login change verification page" do
        param :verify_login_change_key, "Login change verification token", type: :token, required: true

        response 302, "token stored in session"
        html_response "login change verification form"
        redirect_error_response "invalid verify login change key"
      end

      post :verify_login_change, "Perform login change verification" do
        param :verify_login_change_key, "Login change verification token", type: :token, required: json

        success_response "successfully verified login change"
        redirect_error_response :invalid_key, "invalid verify login change key"
        redirect_error_response :invalid_key, "already an account with this login"
      end
    end
  end
end
