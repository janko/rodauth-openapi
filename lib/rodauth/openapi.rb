require "yaml"
require "json"
require "rodauth/version"
require "rodauth/openapi/routes"

module Rodauth
  class OpenAPI
    DOCS_URL = "https://rodauth.jeremyevans.net/documentation.html"
    SPEC_VERSION = "3.0.1"

    def initialize(auth_class, json: nil, password: true)
      @auth_class = auth_class
      @json = json
      @password = password
    end

    def to_yaml
      YAML.dump(JSON.parse(JSON.generate(generate))).lines[1..-1].join
    end

    def to_json
      JSON.pretty_generate(generate)
    end

    def generate
      data = {
        openapi: SPEC_VERSION,
        info: {
          title: "Rodauth",
          description: "This lists all the endpoints provided by Rodauth features.",
          version: Rodauth::VERSION,
        },
        externalDocs: {
          description: "Rodauth documentation",
          url: DOCS_URL,
        },
        tags: [],
        paths: {},
      }

      rodauth.features.each do |feature|
        begin
          require "rodauth/openapi/routes/#{feature}"
        rescue LoadError
          next
        end

        routes = Routes.new(data, rodauth: rodauth, json: json?)
        routes.instance_exec(&Routes::FEATURES[feature])
      end

      # remove tags that don't have any routes
      all_tags = data[:paths].values.flat_map(&:values).flat_map { |route| route[:tags] }.uniq
      data[:tags].select! { |tag| all_tags.include?(tag[:name]) }

      data
    end

    private

    def json?
      @json || rodauth.only_json?
    end

    def rodauth
      rodauth = @auth_class.new(scope)
      rodauth.instance_variable_set(:@has_password, password?)
      rodauth
    end

    def password?
      @password
    end

    def scope
      @auth_class.roda_class.new({ "rack.session" => {} })
    end
  end
end
