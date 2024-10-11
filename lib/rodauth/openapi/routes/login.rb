module Rodauth
  class OpenAPI
    Routes.define :login, "Login" do
      get :login, "View Login page" do
        html_response "login form"
      end

      post :login, "Perform login" do
        param :login, "Email address for the account", type: :email, required: true
        param :password, "Password for the account", type: :password, required: !rodauth.use_multi_phase_login?

        success_response "successful login"
        error_response :no_matching_login, "no matching login"
        error_response :unopen_account, "unverified account"
        error_response :lockout, "account locked out" if feature?(:lockout)
        error_response :login, "invalid password"
      end
    end
  end
end
