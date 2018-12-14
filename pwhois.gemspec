# coding: utf-8
require File.expand_path('../lib/pwhois/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "pwhois"
  spec.version       = Pwhois::VERSION
  spec.authors       = ["Seth Wright"]
  spec.email         = ["seth@crosse.org"]

  spec.summary       = %q{A WHOIS client that provides consistent and coherent results.}
  spec.description   = <<-EOF
    pwhois is a small command-line utility that takes advantage of the
    whois module to parse WHOIS results and display them in a
    consistent, coherent style.
  EOF
  spec.homepage      = "https://github.com/Crosse/pwhois"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.2.3'
  spec.add_runtime_dependency 'whois', '~>3.6'
  spec.add_development_dependency 'rake', '~>11.3'
  spec.add_development_dependency 'rspec', '~>3.8'
  spec.add_development_dependency 'rspec_junit_formatter', '~>0.4'
end
