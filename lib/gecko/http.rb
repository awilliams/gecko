require 'faraday_middleware/multi_json'

module Gecko
  class Http

    class Result
      Error = Struct.new(:text, :status) do
        def to_s
          self.text
        end
      end

      attr_reader :faraday_response
      attr_accessor :faraday_response_env

      def initialize(faraday_response)
        @faraday_response = faraday_response
      end

      def on_complete(&block)
        self.faraday_response.on_complete do |env|
          self.faraday_response_env = env
          block.call(self.success?, self)
        end
      end

      def response_body
        self.faraday_response.body
      end

      def success?
        self.http_200? && !self.error?
      end

      def http_200?
        self.faraday_response.status == 200
      end

      def error?
        self.fetch(:success) != true
      end

      def fetch(*keys)
        keys.inject(self.response_body) do |body_hash, key|
          break unless body_hash
          body_hash.fetch(key, nil)
        end
      end

      def error
        Error.new(self.fetch(:error), self.faraday_response.status)
      end
    end

    def initialize(*args)
      @connection = Faraday.new(*args) do |connection|
        connection.response :multi_json, :symbolize_keys => true
        Gecko.config.connection_builder.call(connection) if Gecko.config.connection_builder.respond_to?(:call)
        yield connection if block_given?
        connection.adapter Faraday.default_adapter if connection.builder.handlers.none? { |handler| handler.klass < Faraday::Adapter }
      end
      self
    end

    def post(*args, &block)
      Result.new(@connection.post(*args, &block))
    end
  end
end