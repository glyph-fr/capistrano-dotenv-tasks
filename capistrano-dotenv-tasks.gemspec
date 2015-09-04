# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/dotenv/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-dotenv-tasks"
  spec.version       = Capistrano::Dotenv::VERSION
  spec.authors       = ["Valentin Ballestrino"]
  spec.email         = ["vala@glyph.fr"]
  spec.summary       = %q{Capistrano tasks to configure your remote dotenv files}
  spec.description   = %q{Capistrano tasks to configure your remote dotenv files}
  spec.homepage      = "https://github.com/glyph-fr/capistrano-dotenv-tasks"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # spec.add_dependency 'capistrano', '~> 3.0'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
