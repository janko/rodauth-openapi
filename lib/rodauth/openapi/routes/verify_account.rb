module Rodauth
  class OpenAPI
    Routes.define :verify_account, "Verify Account" do
      get :verify_account, "View account verification page" do
        param :verify_account_key, "Account verification token", type: :token, required: true

        response 302, "token stored in session"
        if feature?(:webauthn_verify_account)
          html_response "WebAuthn setup form"
        else
          html_response "account verification form"
        end
        redirect_error_response "invalid verify account key"
      end

      post :verify_account, "Perform account verification" do
        if json && feature?(:webauthn_verify_account)
          description <<~MARKDOWN
            In JSON mode, if WebAuthn credential data wasn't provided, input credential params will be returned in the response:
            ```json
            {
              "#{rodauth.webauthn_setup_param}": { ... },
              "#{rodauth.webauthn_setup_challenge_param}": "...",
              "#{rodauth.webauthn_setup_challenge_hmac_param}": "..."
            }
            ```
          MARKDOWN
        end

        param :verify_account_key, "Account verification token", type: :token, required: json
        param :password, "Password to set", type: :password, required: true if rodauth.verify_account_set_password?
        param :password_confirm, "Password confirmation", type: :password, required: true if rodauth.verify_account_set_password? && rodauth.require_password_confirmation?
        if feature?(:webauthn_verify_account)
          param :webauthn_setup, "WebAuthn credential data", type: :object, required: true
          param :webauthn_setup_challenge, "WebAuthn credential challenge", type: :string, required: true
          param :webauthn_setup_challenge_hmac, "WebAuthn credential challenge HMAC", type: :string, required: true
        end

        success_response "successful account verification"
        redirect_error_response :invalid_key, "missing or invalid token"
        error_response :invalid_field, "invalid password" if rodauth.verify_account_set_password?
        error_response :unmatched_field, "passwords do not match" if rodauth.verify_account_set_password? && rodauth.require_password_confirmation?
        error_response :invalid_field, "invalid WebAuthn credential data"
      end

      get :verify_account_resend, "Resend account verification email page" do
        html_response "resend account verification form"
      end

      post :verify_account_resend, "Perform resending account verification email" do
        param :login, "Email address for the account", type: :email, required: true

        success_response "successful resend"
        redirect_error_response "email recently sent"
        error_response :no_matching_login, "no matching login"
      end
    end
  end
end
