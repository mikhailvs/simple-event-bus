lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'event_bus'

Gem::Specification.new do |s|
  s.name = 'event-bus'
  s.version = SimpleEventBus::VERSION
  s.authors = ['Mikhail Slyusarev']
  s.email = ['slyusarevmikhail@gmail.com']
  s.summary = 'Simple event bus.'
  s.homepage = 'https://github.com/mikhailvs/simple-event-bus'
  s.files = ['lib/*.rb']
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
