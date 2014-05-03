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

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
