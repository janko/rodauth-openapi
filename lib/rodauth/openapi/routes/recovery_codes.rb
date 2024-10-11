module Rodauth
  class OpenAPI
    Routes.define :recovery_codes, "Recovery Codes" do
      get :recovery_auth, "View recovery code authentication page" do
        html_response "recovery code authentication form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via recovery code"
      end

      post :recovery_auth, "Authenticate via recovery code" do
        param :recovery_codes, "Recovery code", type: :string, required: true

        success_response "successfully authenticated via recovery code"
        error_response :invalid_key, "invalid recovery code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via recovery code"
      end

      get :recovery_codes, "View recovery codes page" do
        html_response "recovery codes form"

        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end

      post :recovery_codes, "See recovery codes" do
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?
        param :add_recovery_codes, "Whether to create missing recovery codes", type: :boolean

        if json
          json_response("available recovery codes", { "codes": ["..."] })
        else
          html_response "displayed recovery codes"
        end
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end
    end
  end
end
