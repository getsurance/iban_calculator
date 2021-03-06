lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iban_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = 'iban_calculator'
  spec.version       = IbanCalculator::VERSION
  spec.authors       = ['Maximilian Schulz']
  spec.email         = ['m.schulz@kulturfluss.de']
  spec.summary       = 'Calculate IBAN and BIC for countries of Single European Payments Area (SEPA).'
  spec.description   = 'At the moment the gem is just a wrapper for the ibanrechner.de API.'
  spec.homepage      = 'https://github.com/railslove/iban_calculator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'savon', '~> 2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rubocop'
end
