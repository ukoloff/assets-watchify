# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assets/watchify/version'

Gem::Specification.new do |spec|
  spec.name          = "assets-watchify"
  spec.version       = Assets::Watchify::VERSION
  spec.authors       = ["Stas Ukolov"]
  spec.email         = ["ukoloff@gmail.com"]
  spec.summary       = 'Fast serving Rails assets in development'
  spec.description   = ''
  spec.homepage      = "https://github.com/ukoloff/assets-watchify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties"
  spec.add_dependency 'source_map'
  spec.add_dependency 'listen'
  # Windows dependencies
  spec.add_dependency 'wdm'
  spec.add_dependency 'execjs-xtrn'
  spec.add_dependency 'openssl-win-root'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
