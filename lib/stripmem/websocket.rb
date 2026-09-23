# frozen_string_literal: true

require 'em-websocket'
require 'json'

class StripMem::WebSocket
  def initialize(channel)
    @channel = channel
    @data = []
    @channel.subscribe { |msg| @data << msg }
  end

  def run!
    EventMachine::WebSocket.start(host: 'localhost', port: 9998) do |ws|
      ws.onopen do
        # rubocop:disable Style/Send
        @data.each { |msg| ws.send(JSON.generate(msg)) }
        sid = @channel.subscribe { |msg| ws.send(JSON.generate(msg)) }
        ws.onclose { @channel.unsubscribe(sid) }
        # rubocop:enable Style/Send
      end
    end
  end
end
