require File.expand_path('lib/globe_labs/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name = 'globe_labs'
  s.version = GlobeLabs::VERSION
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Jaemar Ramos']
  s.email = ['jaemar.ramos@gmail.com']
  s.description = 'Globe Labs Client Library for Ruby'
  s.summary = 'Ruby client library for Globe Labs\' API.'
  s.required_ruby_version = '>= 1.9.3'

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest', '~> 5.0')

  if RUBY_VERSION == '1.9.3'
    s.add_development_dependency('addressable', '< 2.5.0')
    s.add_development_dependency('webmock', '~> 1.0')
  else
    s.add_development_dependency('webmock', '~> 2.0')
  end

  s.files = Dir.glob('{lib,spec}/**/*') + %w(LICENSE.txt README.md globe_labs.gemspec)
  s.require_paths = ["lib"]
end