module Rodauth
  class OpenAPI
    class Routes
      FEATURES = {}

      def self.define(name, tag, &definition)
        FEATURES[name] = -> do
          section tag, name
          instance_exec(&definition)
        end
      end

      attr_reader :data, :rodauth, :json

      def initialize(data, rodauth:, json:)
        @data = data
        @rodauth = rodauth
        @json = json
      end

      def section(tag, name)
        data[:tags] << {
          name: tag,
          externalDocs: {
            description: "Feature documentation",
            url: "http://rodauth.jeremyevans.net/rdoc/files/doc/#{name}_rdoc.html"
          }
        }
      end

      def get(...)
        route(:get, ...) unless json
      end

      def post(...)
        route(:post, ...)
      end

      def route(verb, name, summary, &block)
        path = rodauth.send(:"#{name}_path")
        return if path.nil?

        tag = data[:tags].last[:name]

        data[:paths][path] ||= {}
        data[:paths][path][verb] = {
          tags: [tag],
          summary: summary,
          description: <<~MARKDOWN,
            ```ruby
            #{rodauth_invocation}.#{name}_route #=> "#{rodauth.send(:"#{name}_route")}"
            #{rodauth_invocation}.#{name}_path #=> "#{path}"
            #{rodauth_invocation}.#{name}_url #=> "https://example.com#{path}"

            #{rodauth_invocation}.current_route #=> :#{name} (in the request)
            ```
          MARKDOWN
          responses: {},
          parameters: [],
        }

        instance_exec(&block)
      end

      def description(text)
        path = data[:paths].values.last.values.last
        path[:description] = [path[:description], text].compact.join("\n")
      end

      def param(name, description, type:, example: nil, required: false, enum: nil)
        example ||= case type
        when :email then "user@example.com"
        when :password then "secret123"
        when :boolean then "true"
        when :token then "{account_id}#{rodauth.token_separator}{key_hmac}"
        end

        parameters = data[:paths].values.last.values.last[:parameters]
        parameters << {
          name: rodauth.send(:"#{name}_param"),
          in: "query",
          description: description,
          required: required,
          style: "form",
          example: example,
          schema: { type: type == :boolean ? "boolean" : "string", enum: enum }.compact,
        }.compact
      end

      def html_response(description)
        response(200, description)
      end

      def json_response(description = "", example)
        response(200, description, content: { "application/json" => { example: example } })
      end

      def success_response(description)
        status = json ? 200 : 302
        response(status, description)
      end

      def error_response(status = nil, description)
        status = rodauth.send(:"#{status}_error_status") if status.is_a?(Symbol)
        if json && (status.nil? || !rodauth.json_response_custom_error_status?)
          status = rodauth.json_response_error_status
        end
        response(status, description)
      end

      def redirect_error_response(name = nil, description)
        status = if json
          if rodauth.json_response_custom_error_status? && name
            rodauth.send(:"#{name}_error_status")
          else
            rodauth.json_response_error_status
          end
        else
          302
        end
        response(status, description)
      end

      def response(status, description = "", **fields)
        responses = data[:paths].values.last.values.last[:responses]
        if responses[status]
          responses[status][:description] = [responses[status][:description], description].join(", ")
        else
          responses[status] = { description: description }
        end
        responses[status].merge!(fields)
      end

      def feature?(name)
        rodauth.features.include?(name)
      end

      def rodauth_invocation
        if rodauth.class.configuration_name
          "rodauth(:#{rodauth.class.configuration_name})"
        else
          "rodauth"
        end
      end
    end
  end
end
