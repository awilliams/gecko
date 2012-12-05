require 'faraday_middleware/multi_json'

module Gecko
  class Http
    def initialize(*args)
      @connection = Faraday.new(*args) do |connection|
        connection.response :multi_json, :symbolize_keys => true
        Gecko.config.connection_builder.call(connection) if Gecko.config.connection_builder.respond_to?(:call)
        yield connection if block_given?
        connection.adapter Faraday.default_adapter if connection.builder.handlers.none? { |handler| handler.klass < Faraday::Adapter }
      end
      self
    end

    def headers
      {
        :accept => 'application/json',
        :user_agent => Gecko.config.http_user_agent
      }
    end

    def encode_body(body)
      MultiJson.encode(body)
    end

    def post(url, body, &request_block)
      Result.new(@connection.post(url, self.encode_body(body), self.headers, &request_block))
    end

    class Result
      Error = Struct.new(:text, :status) do
        def to_s
          self.text
        end
      end

      attr_reader :response
      attr_accessor :response_env

      def initialize(response)
        @response = response
      end

      def on_complete(&block)
        self.response.on_complete do |env|
          self.response_env = env
          block.call(self.success?, self)
        end
      end

      def response_body
        self.response.body
      end

      def success?
        self.http_200? && !self.error?
      end

      def http_200?
        self.response.status == 200
      end

      def error?
        self.fetch(:success) != true
      end

      def error
        Error.new(self.fetch(:error), self.response.status)
      end

      def fetch(*keys)
        keys.inject(self.response_body) do |body_hash, key|
          break unless body_hash
          body_hash.fetch(key, nil)
        end
      end
    end
  end
end