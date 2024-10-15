# Rodauth OpenAPI

Generate [OpenAPI] documentation for your Rodauth endpoints.

## Installation

```sh
bundle add rodauth-openapi --group development
```

## Usage

The generated OpenAPI documentation can be uploaded to renderers such as [Swagger Editor] or [Redoc].

### In Rails

Assuming you have Rodauth installed in your Rails application, you can use the generator provided by this gem:

```sh
rails g rodauth:openapi
```

This will generate OpenAPI documentation in YAML format for the default Rodauth configuration and print it to standard output.

The generator accepts the following options:

```sh
rails g rodauth:openapi --name admin # secondary configuration
rails g rodauth:openapi --format json # JSON format
rails g rodauth:openapi --json # generate JSON API endpoints
rails g rodauth:openapi --no-password # assume account without password
rails g rodauth:openapi --save openapi.yml # save to a file
```

### Outside of Rails

If you're not using Rails, you can generate the OpenAPI documentation programmatically:

```rb
require "rodauth/openapi"

auth_class = RodauthApp.rodauth # or RodauthApp.rodauth(:admin)
open_api = Rodauth::OpenAPI.new(auth_class)

File.write("openapi.yml", open_api.to_yaml)
```

Here are the various options and methods supported:

```rb
Rodauth::OpenAPI.new(auth_class, json: true) # generate JSON API endpoints
Rodauth::OpenAPI.new(auth_class, password: false) # assume account has no password

Rodauth::OpenAPI.new(auth_class).to_yaml # YAML format
Rodauth::OpenAPI.new(auth_class).to_json # JSON format
Rodauth::OpenAPI.new(auth_class).generate # ruby hash
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rodauth::Openapi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/janko/rodauth-openapi/blob/main/CODE_OF_CONDUCT.md).

[OpenAPI]: https://swagger.io/specification/
[Swagger Editor]: https://editor.swagger.io/
[Redoc]: https://redocly.github.io/redoc/
