module Rodauth
  class OpenAPI
    Routes.define :two_factor_base, "Two Factor Base" do
      route (json ? :post : :get), :two_factor_manage, "View two factor management page" do
        if json
          json_response({ "setup_links": ["..."], "remove_links": ["..."] })
        else
          html_response "two factor management page"
        end
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end

      route (json ? :post : :get), :two_factor_auth, "View two factor authentication page" do
        if json
          json_response({ "auth_links": ["..."] })
        else
          html_response "two factor authentication page"
        end
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :two_factor_already_authenticated, "2nd factor already authenticated"
      end

      get :two_factor_disable, "View two factor disable page" do
        html_response "two factor disable page"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end

      post :two_factor_disable, "Disable two factor authentication" do
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "2nd factor successfully disabled"
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end
    end
  end
end
