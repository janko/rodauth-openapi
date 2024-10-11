module Rodauth
  class OpenAPI
    Routes.define :webauthn, "WebAuthn" do
      get :webauthn_auth, "View WebAuthn authentication page" do
        html_response "WebAuthn authentication form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via WebAuthn"
        redirect_error_response :webauthn_not_setup, "WebAuthn not setup"
      end

      post :webauthn_auth, "Perform WebAuthn authentication" do
        if json
          description <<~MARKDOWN
            In JSON mode, if credential data wasn't provided, input credential params will be returned in the response:
            ```json
            {
              "#{rodauth.webauthn_auth_param}": { ... },
              "#{rodauth.webauthn_auth_challenge_param}": "...",
              "#{rodauth.webauthn_auth_challenge_hmac_param}": "..."
            }
            ```
          MARKDOWN
        end

        param :webauthn_auth, "Credential data", type: :object, required: true
        param :webauthn_auth_challenge, "Credential challenge", type: :string, required: true
        param :webauthn_auth_challenge_hmac, "Credential challenge HMAC", type: :string, required: true

        success_response "successfully authenticated via WebAuthn"
        error_response :invalid_key, "invalid credential data"
        error_response :invalid_field, "invalid credential sign count"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via WebAuthn"
        redirect_error_response :webauthn_not_setup, "WebAuthn not setup"
      end

      get :webauthn_setup, "View WebAuthn setup page" do
        html_response "WebAuthn setup form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end

      post :webauthn_setup, "Perform WebAuthn setup" do
        if json
          description <<~MARKDOWN
            In JSON mode, if credential data wasn't provided, input credential params will be returned in the response:
            ```json
            {
              "#{rodauth.webauthn_setup_param}": { ... },
              "#{rodauth.webauthn_setup_challenge_param}": "...",
              "#{rodauth.webauthn_setup_challenge_hmac_param}": "..."
            }
            ```
          MARKDOWN
        end

        param :webauthn_setup, "Credential data", type: :object, required: true
        param :webauthn_setup_challenge, "Credential challenge", type: :string, required: true
        param :webauthn_setup_challenge_hmac, "Credential challenge HMAC", type: :string, required: true
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "WebAuthn successfully setup"
        error_response :invalid_field, "invalid credential data"
        error_response :invalid_field, "duplicate credential ID"
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
      end

      get :webauthn_remove, "View WebAuthn authenticator removal page" do
        html_response "WebAuthn authenticator removal form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :webauthn_not_setup, "WebAuthn not setup"
      end

      post :webauthn_remove, "Remove WebAuthn authenticator" do
        if json
          description <<~MARKDOWN
            In JSON mode, if credential ID wasn't provided, last usage of every credential will be returned in the response:
            ```json
            {
              "#{rodauth.webauthn_remove_param}": {
                "abc123": "2024-10-10 00:37:10 UTC"
              }
            }
            ```
          MARKDOWN
        end

        param :webauthn_remove, "Credential ID", type: :string, required: true
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "WebAuthn authenticator successfully removed"
        error_response :invalid_field, "invalid credential ID"
        error_response :invalid_password, "invalid password" if rodauth.two_factor_modifications_require_password?
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :webauthn_not_setup, "WebAuthn not setup"
      end
    end
  end
end
