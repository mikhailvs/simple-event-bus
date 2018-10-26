# frozen_string_literal: true

describe SimpleEventBus do
  before(:each) { @bus = SimpleEventBus.new }

  it 'handles events with blocks' do
    ran = false

    @bus.subscribe(:test_event) { ran = true }

    expect(ran).to be(false)

    @bus.emit(:test_event)

    expect(ran).to be(true)
  end

  it 'handles events with objects' do
    event_handler = Class.new do
      attr_reader :ran

      def initialize
        @ran = false
      end

      def test_event
        @ran = true
      end
    end

    handler = event_handler.new

    @bus.subscribe(:test_event, handler)

    expect(handler.ran).to be(false)

    @bus.emit(:test_event)

    expect(handler.ran).to be(true)
  end

  it 'emits events without handlers' do
    expect { @bus.emit(:event_with_no_handler) }.to_not raise_error
  end

  it 'calls handlers every time' do
    counter = 0
    @bus.subscribe(:increment) { counter += 1 }

    50.times { @bus.emit(:increment) }

    expect(counter).to equal(50)
  end

  it 'calls handlers just once with once: true' do
    counter = 0
    @bus.subscribe(:increment, once: true) { counter += 1 }

    10.times { @bus.emit(:increment) }

    expect(counter).to equal(1)
  end

  it 'removes handlers' do
    counter = 0
    id = @bus.subscribe(:increment) { counter += 1 }

    @bus.emit(:increment)

    @bus.unsubscribe(:increment, id)

    5.times { @bus.emit(:increment) }

    expect(counter).to equal(1)
  end

  it 'works as a singleton' do
    ran = false

    SimpleEventBus.subscribe(:test_event) { ran = true }

    expect(ran).to be(false)

    SimpleEventBus.emit(:test_event)

    expect(ran).to be(true)
  end
end
