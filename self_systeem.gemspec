# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'self_systeem/version'

Gem::Specification.new do |spec|
  spec.name          = "self_systeem"
  spec.version       = SelfSysteem::VERSION
  spec.authors       = ["Mike Piccolo"]
  spec.email         = ["mpiccolo@newleaders.com"]
  spec.summary       = %q{Unconfident in you system testing? Boost your Self Systeem.}
  spec.description   = %q{System testing by recording actual user interactions}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails",  ">= 4.0"
  spec.add_runtime_dependency "minitest", ">= 4.5", "<= 5.3.3"
  spec.add_runtime_dependency "database_cleaner", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "minitest-spec-rails", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.3.1"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "pry", "~> 0.9"
  spec.add_development_dependency "pry-debugger", "~> 0.2"
  spec.add_development_dependency "devise", "~> 3.2.4"
  spec.add_development_dependency "devise_invitable", "~> 1.3.4"
  spec.add_development_dependency "pg", "~> 0.17.1"
  spec.add_development_dependency "simple_form", "~> 3.0.2"
  spec.add_development_dependency "sass", "~> 3.2.19"
  spec.add_development_dependency "money-rails", "~> 0.10.0"
  spec.add_development_dependency "foreigner", "~> 1.6.1"
  spec.add_development_dependency "mocha", "~> 1.0.0"
end
