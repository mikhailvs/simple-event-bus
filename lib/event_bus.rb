require 'forwardable'

class SimpleEventBus
  VERSION = '0.1.0'.freeze

  class << self
    extend Forwardable

    private

    def instance
      @instance ||= new
    end

    def_delegators :instance, :emit, :subscribe, :unsubscribe
  end

  def initialize
    @subscribers = handler_hash
    @once = handler_hash
  end

  def emit(event, **params)
    caller = handler_caller(event, params)

    @subscribers[event].each(&caller)
    @once[event].delete_if(&caller)

    nil
  end

  def subscribe(event, obj_hlr = nil, once: false, &hlr)
    handler = hlr || obj_hlr

    raise ArgumentError, 'object or proc handler required' if handler.nil?

    (once ? @once : @subscribers)[event][handler.object_id] = handler
  end

  def unsubscribe(event, id)
    @subscribers[event].delete(id)
  end

  private

  def handler_hash
    Hash.new { |h, k| h[k] = {} }
  end

  def handler_caller(event, params)
    proc do |_id, handler|
      if handler.is_a?(Proc)
        handler.call(params)
      else
        handler.send(event, params)
      end

      true
    end
  end
end
