module Rodauth
  class OpenAPI
    Routes.define :sms_codes, "SMS Codes" do
      get :sms_request, "View SMS code request page" do
        html_response "SMS code request form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via SMS code"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
        redirect_error_response :lockout, "SMS codes locked out"
      end

      post :sms_request, "Request SMS code" do
        success_response "SMS code successfully sent"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via SMS code"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
        redirect_error_response :lockout, "SMS codes locked out"
      end

      get :sms_auth, "View SMS code authentication page" do
        html_response "SMS code authentication form"
        redirect_error_response :invalid_key, "no current SMS code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via SMS code"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
        redirect_error_response :lockout, "SMS codes locked out"
      end

      post :sms_auth, "Authenticate via SMS code" do
        param :sms_code, "SMS code", type: :string, required: true

        success_response "successfully authenticated via SMS code"
        error_response :invalid_key, "invalid SMS code"
        redirect_error_response :invalid_key, "no current SMS code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_already_authenticated, "already authenticated via SMS code"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
        redirect_error_response :lockout, "SMS codes locked out"
      end

      get :sms_setup, "View SMS codes setup page" do
        html_response "SMS codes setup form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :sms_already_setup, "SMS codes already setup"
        redirect_error_response :sms_needs_confirmation, "SMS phone number needs confirmation"
      end

      post :sms_setup, "Setup SMS codes" do
        param :sms_phone, "SMS phone number", type: :string, required: true
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "SMS codes successfully setup"
        error_response :invalid_field, "invalid phone number"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :sms_already_setup, "SMS codes already setup"
        redirect_error_response :sms_needs_confirmation, "SMS phone number needs confirmation"
      end

      get :sms_confirm, "View SMS phone number confirmation page" do
        html_response "SMS confirmation form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :sms_already_setup, "SMS codes already setup"
      end

      post :sms_confirm, "Confirm SMS phone number" do
        param :sms_code, "SMS code", type: :string, required: true

        success_response "SMS phone number successfully confirmed"
        error_response :invalid_key, "invalid SMS code"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "2nd factor not setup"
        redirect_error_response :sms_already_setup, "SMS codes already setup"
      end

      get :sms_disable, "View SMS disable page" do
        html_response "SMS disable form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
      end

      post :sms_disable, "Disable SMS codes" do
        param :password, "Current account password", type: :password, required: true if rodauth.two_factor_modifications_require_password?

        success_response "SMS codes successfully disabled"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2nd factor required"
        redirect_error_response :two_factor_not_setup, "SMS codes not setup"
      end
    end
  end
end
