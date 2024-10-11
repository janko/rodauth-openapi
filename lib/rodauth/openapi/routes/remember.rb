module Rodauth
  class OpenAPI
    Routes.define :remember, "Remember" do
      get :remember, "View remember settings page" do
        html_response "remember settings form"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end

      post :remember, "Change remember settings" do
        param :remember, "Remember action to perform", type: :string, required: true, enum: [
          rodauth.remember_remember_param_value,
          rodauth.remember_forget_param_value,
          rodauth.remember_disable_param_value,
        ]

        success_response "remember setting successfully changed"
        error_response :invalid_field, "invalid remember param"
        redirect_error_response :login_required, "login required"
        redirect_error_response :two_factor_need_authentication, "2FA required" if feature?(:two_factor_base)
      end
    end
  end
end
