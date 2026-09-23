# frozen_string_literal: true

require File.expand_path('lib/strip_mem/version', File.dirname(__FILE__))
Gem::Specification.new do |spec|
  spec.name    = 'runger_stripmem'
  spec.version = StripMem::VERSION
  spec.summary = spec.description = 'Stripchart memory usage'
  spec.homepage = 'https://github.com/davidrunger/runger_stripmem'
  spec.authors = ['Matt Burke', 'David Runger']
  spec.email   = 'davidjrunger@gmail.com'
  spec.license = 'MIT'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files   = Dir['lib/**/*', 'README.md', 'LICENSE']
  spec.bindir  = 'exe'
  spec.executables = %w[
    stripmem
  ]

  spec.add_dependency('em-websocket', '>= 0.5.3')
  spec.add_dependency('eventmachine', '>= 1.2.7')
  spec.add_dependency('json', '>= 3.0.2')
  spec.add_dependency('puma', '>= 8.0.2')
  spec.add_dependency('rackup', '>= 2.3.1')
  spec.add_dependency('sinatra', '>= 4.2.1')

  required_ruby_version = File.read('.ruby-version').rstrip.sub(/\A(\d+\.\d+)\.\d+\z/, '\1.0')
  spec.required_ruby_version = ">= #{required_ruby_version}"
end
