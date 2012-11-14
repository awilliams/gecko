module Gecko
  class Configurator
    attr_accessor :api_key
    attr_reader :connection_builder

    # Block invoked with Faraday builder when creating a connection
    def http_builder(&block)
      @connection_builder = block
    end

  end
end