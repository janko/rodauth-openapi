require "rodauth/openapi"
require "rails/generators"

module Rodauth
  module Generators
    class OpenAPIGenerator < ::Rails::Generators::Base
      namespace "rodauth:openapi"

      class_option :password, type: :boolean, default: true,
        desc: "Whether to assume the account has a password"

      class_option :json, type: :boolean,
        desc: "Whether to generate JSON API documentation"

      class_option :name, type: :string, default: nil,
        desc: "The configuration name for which to generate documentation"

      class_option :format, type: :string, default: "yaml",
        desc: "The format to output the documentation in (yaml, json)"

      class_option :save, type: :string, default: nil,
        desc: "File to save the documentation to (by default prints to stdout)"

      def print_documentation
        open_api = Rodauth::OpenAPI.new(auth_class, password: options[:password], json: options[:json])
        documentation = open_api.public_send(:"to_#{options[:format]}")

        if options[:save]
          File.write(options[:save], documentation)
        else
          puts documentation
        end
      end

      private

      def auth_class
        Rodauth::Rails.app.rodauth!(configuration_name)
      end

      def configuration_name
        options[:name]&.to_sym
      end
    end
  end
end
