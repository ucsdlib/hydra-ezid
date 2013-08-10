lib = File.expand_path('../lib', __FILE__)
 $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hydra/ezid/version'

Gem::Specification.new do |s|
  s.name          = 'hydra-ezid'
  s.version       = Hydra::Ezid::VERSION
  s.authors       = ['Michael J. Giarlo']
  s.email         = ['leftwing@alumni.rutgers.edu']
  s.summary       = 'A Ruby gem providing EZID services for Hydra applications'
  s.description   = 'A Ruby gem providing EZID services for Hydra applications'
  s.homepage      = 'https://github.com/psu-stewardship/hydra-ezid'
  s.license       = 'APACHE2'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 3.2.13', '< 5.0'
  s.add_dependency 'active-fedora'
  s.add_dependency 'ezid'

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'jettywrapper'
  s.add_development_dependency 'rspec'
end
