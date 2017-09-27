# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kajian/version'

Gem::Specification.new do |spec|
  spec.name          = "kajian"
  spec.version       = Kajian::VERSION
  spec.authors       = ["Adrian Setyadi"]
  spec.email         = ["adrian@setyadi.pro"]
  spec.summary       = %q{Pustaka ruby untuk mengekstrak data acara kajian Islam dari berbagai situs di Indonesia.}
  spec.description   = %q{Pustaka ruby untuk mengekstrak data acara kajian Islam dari berbagai situs di Indonesia. Dengan menggunakan DSL (Domain Specific Language), mudah untuk menambahkan situs-situs lain untuk diekstrak data acara kajiannya.}
  spec.homepage      = "https://github.com/styd/kajian"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
