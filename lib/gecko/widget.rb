module Gecko
  class Widget
    attr_reader :data, :keys

    def initialize(*keys, &block)
      self.keys = *keys
      @on_update = nil
      block.call(self) if block
      raise ArgumentError, "1 or more widget keys are required" if self.keys.empty?
    end

    def keys=(*keys)
      @keys = keys.flatten.compact
    end

    def on_update(&block)
      @on_update = block
      self
    end

    def push_url(key)
      Gecko.config.api_push_url.gsub(/:widget_key/, key)
    end

    def update(&on_update)
      self.keys.map do |key|
        request = Gecko::Http.new(self.push_url(key)).post do |req|
          req.body = MultiJson.dump(self.payload)
        end
        request.on_complete do |*args|
          @on_update.call(*args) if @on_update.respond_to?(:call)
          on_update.call(*args) if on_update
        end
        request
      end
    end

    def config(&block)
      block.call(self)
      self
    end

    def config!(&block)
      self.config(&block).update
      self
    end

    def data_payload
      {}
    end

    def payload
      {
        :api_key => Gecko.config.api_key,
        :data => self.data_payload
      }
    end
  end
end

require 'gecko/widget/number_secondary_stat'
require 'gecko/widget/rag'
require 'gecko/widget/rag_columns'
require 'gecko/widget/text'

require 'gecko/graph/pie'
require 'gecko/graph/geckometer'
require 'gecko/graph/funnel'
require 'gecko/graph/line'