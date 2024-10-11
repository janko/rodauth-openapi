module Rodauth
  class OpenAPI
    Routes.define :webauthn_login, "WebAuthn Login" do
      post :webauthn_login, "Perform WebAuthn login" do
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

        param :login, "Account email", type: :email, required: !feature?(:webauthn_autofill)
        param :webauthn_auth, "Credential data", type: :object, required: true

        success_response "successfully logged in via WebAuthn"
        error_response :invalid_key, "invalid credential data"
        error_response :invalid_field, "invalid credential sign count"
        error_response :invalid_field, "credential not found" if feature?(:webauthn_autofill)
        error_response :no_matching_login, "no matching login"
      end
    end
  end
end
