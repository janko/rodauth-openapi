module Rodauth
  class OpenAPI
    Routes.define :otp, "OTP" do
      get :otp_auth, "View TOTP authentication page" do
        html_response "TOTP authentication form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via TOTP"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
        redirect_error_response :lockout, "TOTP locked out"
      end

      post :otp_auth, "Perform TOTP authentication" do
        param :otp_auth, "TOTP code", type: :string, required: true

        success_response "successfully authenticated via TOTP"
        error_response :invalid_key, "invalid TOTP code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via TOTP"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
        redirect_error_response :lockout, "TOTP locked out"
      end

      get :otp_setup, "View TOTP setup page" do
        html_response "TOTP setup form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response "TOTP already setup"
      end

      post :otp_setup, "Perform TOTP setup" do
        if json
          description <<~MARKDOWN
            In JSON mode, if TOTP secret wasn't provided (and HMACs are used), the response will include a valid TOTP secret that can be included in the subsequent setup request:
            ```json
            {
              "#{rodauth.otp_setup_param}": "...",
              "#{rodauth.otp_setup_raw_param}": "..."
            }
            ```
          MARKDOWN
        end

        param :otp_setup, "TOTP secret", type: :string, required: true
        param :otp_setup_raw, "TOTP raw secret", type: :string, required: true if rodauth.otp_keys_use_hmac?
        param :otp_auth, "TOTP code", type: :string, required: true
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "TOTP successfully setup"
        error_response :invalid_field, "invalid TOTP secret"
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        error_response :invalid_key, "Invalid TOTP code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response "TOTP already setup"
      end

      get :otp_disable, "View TOTP disable page" do
        success_response "TOTP disable form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
      end

      post :otp_disable, "Perform TOTP disable" do
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "TOTP successfully disabled"
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
      end
    end
  end
end
