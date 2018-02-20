# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'fluent-plugin-humio'
  s.version       = '0.0.1'
  s.authors       = ['adam']
  s.email         = ['adamenger@gmail.com']
  s.description   = %q{Humio output plugin for Fluent event collector}
  s.summary       = s.description
  s.homepage      = 'https://github.com/adamenger/fluent-plugin-humio'
  s.license       = 'Apache-2.0'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)

  s.add_runtime_dependency 'fluentd', '~> 1.1'
  s.add_runtime_dependency 'httparty', '= 0.16.0'


  s.add_development_dependency 'rake', '>= 0'
  s.add_development_dependency 'webmock', '~> 1'
  s.add_development_dependency 'test-unit', '~> 3.1.0'
  s.add_development_dependency 'minitest', '~> 5.8'
  s.add_development_dependency 'flexmock', '~> 2.0'
end
