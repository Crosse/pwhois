# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "pwhois"
  spec.version       = "1.0.0"
  spec.authors       = ["Seth Wright"]
  spec.email         = ["seth@crosse.org"]

  spec.summary       = %q{Parse whois results and display them in a coherent style.}
  spec.homepage      = "https://github.com/Crosse/pwhois"
  spec.license       = "ISC"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["pwhois"]
end
