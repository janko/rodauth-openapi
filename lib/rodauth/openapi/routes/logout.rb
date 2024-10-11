module Rodauth
  class OpenAPI
    Routes.define :logout, "Logout" do
      get :logout, "View logout page" do
        html_response "logout form"
      end

      post :logout, "Perform logout" do
        param :global_logout, "Whether to logout all active sessions", type: :boolean if feature?(:active_sessions)
        param :jwt_refresh_token_key, "JWT refresh token to delete (\"all\" deletes all tokens)", type: :string if feature?(:jwt_refresh)

        success_response "successful logout"
      end
    end
  end
end
