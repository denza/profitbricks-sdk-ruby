# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'profitbricks/version'

Gem::Specification.new do |spec|
  spec.name          = "profitbricks-sdk-ruby"
  spec.version       = ProfitBricks::VERSION
  spec.authors       = ["Ethan Devenport"]
  spec.email         = ["ethand@stackpointcloud.com"]
  spec.summary       = %q{Official ProfitBricks SDK for Ruby}
  spec.description   = %q{The ProfitBricks SDK for Ruby provides integration with the ProfitBricks cloud environment over the available REST API.}
  spec.homepage      = "https://github.com/profitbricks/profitbricks-sdk-ruby"
  spec.license       = "Apache"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "excon", "~> 0.44"
  spec.add_runtime_dependency "json", "~> 1.8"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
end