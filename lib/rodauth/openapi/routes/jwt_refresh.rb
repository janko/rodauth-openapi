module Rodauth
  class OpenAPI
    Routes.define :jwt_refresh, "JWT Refresh" do
      post :jwt_refresh, "Refresh JWT access token" do
        param :jwt_refresh_token_key, "JWT refresh token", type: :string, required: true

        json_response({ rodauth.jwt_refresh_token_key => "...", rodauth.jwt_access_token_key => "..." })
        error_response rodauth.jwt_refresh_without_access_token_status, "no JWT access token provided"
        error_response "invalid JWT refresh token"
      end if json
    end
  end
end
