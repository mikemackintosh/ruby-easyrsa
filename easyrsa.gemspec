# Created by hand, like a real man
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easyrsa/version'

Gem::Specification.new do |s|

  s.name        = 'easyrsa'
  s.version     = EasyRSA::VERSION
  s.date        = Time.now.to_s.split(' ').first
  s.summary     = 'EasyRSA interface for generating OpenVPN certificates'
  s.description = 'Easily generate OpenVPN certificates without needing the easyrsa packaged scripts'
  s.authors     = ['Mike Mackintosh']
  s.email       = 'm@zyp.io'
  s.homepage    =
    'http://github.com/mikemackintosh/ruby-easyrsa'

  s.license       = 'MIT'
  
  s.require_paths = ['lib']
  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'paint'
  s.add_dependency 'methadone'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

end
