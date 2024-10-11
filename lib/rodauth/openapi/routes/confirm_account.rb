module Rodauth
  class OpenAPI
    Routes.define :confirm_password, "Confirm Password" do
      get :confirm_password, "View password confirmation page" do
        html_response "password confirmation form"
        redirect_error_response :login_required, "login required"
      end

      post :confirm_password, "Perform password confirmation" do
        param :password, "Current account password", type: :password, required: true

        success_response "password successfully confirmed"
        error_response :invalid_password, "invalid password"
        redirect_error_response :login_required, "login required"
      end
    end
  end
end
