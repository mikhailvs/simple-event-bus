# frozen_string_literal: true

require 'forwardable'

class SimpleEventBus
  VERSION = '0.1.1'

  class << self
    extend Forwardable

    def [](*events)
      Module.new.tap do |m|
        m.define_singleton_method(:included) do |base|
          events.each { |e| SimpleEventBus.subscribe(e, base) }
        end
      end
    end

    def instance
      @instance ||= new
    end

    def_delegators :instance, :emit, :subscribe, :unsubscribe
  end

  def initialize
    @subscribers = handler_hash
    @once = handler_hash
  end

  def emit(event, *args)
    caller = handler_caller(event, args)

    @subscribers[event].each(&caller)
    @once[event].delete_if(&caller)

    nil
  end

  def subscribe(event, obj_hlr = nil, once: false, &hlr)
    handler = hlr || obj_hlr

    raise ArgumentError, 'object or proc handler required' if handler.nil?

    (once ? @once : @subscribers)[event][handler.object_id] = handler

    handler.object_id
  end

  def unsubscribe(event, id)
    @subscribers[event].delete(id)
  end

  private

  def handler_hash
    Hash.new { |h, k| h[k] = {} }
  end

  def handler_caller(event, args)
    proc do |_id, handler|
      if handler.is_a?(Proc)
        handler.call(*args)
      else
        handler.send(event, *args)
      end

      true
    end
  end
end
