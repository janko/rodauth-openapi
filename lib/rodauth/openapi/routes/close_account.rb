module Rodauth
  class OpenAPI
    Routes.define :close_account, "Close Account" do
      get :close_account, "View close account page" do
        html_response "close account form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end

      post :close_account, "Perform closing account" do
        param :password, "Current account password", type: :password, required: true if rodauth.close_account_requires_password?

        success_response "account successfully closed"
        error_response :invalid_password, "invalid password" if rodauth.close_account_requires_password?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end
    end
  end
end
