lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'hydra/ezid/version'

Gem::Specification.new do |s|
  s.name          = 'hydra-ezid'
  s.version       = Hydra::Ezid::VERSION
  s.authors       = ['Michael J. Giarlo']
  s.email         = ['leftwing@alumni.rutgers.edu']
  s.summary       = 'A Rails engine providing EZID services for Hydra applications'
  s.description   = 'A Rails engine providing EZID services for Hydra applications'
  s.homepage      = 'https://github.com/psu-stewardship/hydra-ezid'
  s.license       = 'APACHE2'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'blacklight'
  s.add_dependency 'hydra-head'
  s.add_dependency 'ezid'
  s.add_dependency 'constantinople'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails', '< 5', '>= 3.2'
end
