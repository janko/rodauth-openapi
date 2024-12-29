Gem::Specification.new do |spec|
  spec.name          = "rodauth-openapi"
  spec.version       = "0.2.0"
  spec.authors       = ["Janko Marohnić"]
  spec.email         = ["janko.marohnic@gmail.com"]

  spec.summary       = %q{Allows dynamically generating OpenAPI documentation based on Rodauth configuration.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/janko/rodauth-openapi"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.5"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/*", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rodauth"
end
