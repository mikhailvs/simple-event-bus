# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'event-bus'

Gem::Specification.new do |s|
  s.name = 'simple-event-bus'
  s.version = SimpleEventBus::VERSION
  s.authors = ['Mikhail Slyusarev']
  s.email = ['slyusarevmikhail@gmail.com']
  s.summary = 'Simple event bus. Easily emit and handle events.'
  s.homepage = 'https://github.com/mikhailvs/simple-event-bus'
  s.files = ['lib/event-bus.rb', 'lib/event_bus.rb']
  s.require_paths = ['lib']
  s.license = 'MIT'

  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.60'
end
