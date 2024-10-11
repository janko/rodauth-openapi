module Rodauth
  class OpenAPI
    Routes.define :otp_unlock, "OTP Unlock" do
      get :otp_unlock, "View TOTP unlock page" do
        html_response "TOTP unlock form"
        redirect_error_response :otp_unlock_not_locked_out, "TOTP not locked out"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
      end

      post :otp_unlock, "Perform TOTP unlock step" do
        if json
          description <<~MARKDOWN
            In JSON mode, the response of TOTP unlock steps will include progress information:
            ```json
            {
              "num_successes": 2,
              "required_successes": 3,
              "next_attempt_after": 1728512721,
              "deadline": 1728512769
            }
            ```
          MARKDOWN
        end

        param :otp_auth, "TOTP code", type: :string, required: true

        success_response "TOTP authentication successful, TOTP successfully unlocked"
        error_response :otp_unlock_auth_failure, "TOTP code invalid"
        redirect_error_response :otp_unlock_auth_deadline_passed, "TOTP unlock deadline passed"
        redirect_error_response :otp_unlock_auth_not_yet_available, "TOTP unlock not yet available"
        redirect_error_response :otp_unlock_not_locked_out, "TOTP not locked out"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_not_setup, "TOTP not setup"
      end
    end
  end
end
