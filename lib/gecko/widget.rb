module Gecko
  class Widget
    BASE_URL = 'https://push.geckoboard.com/v1/send/:widget_key'

    attr_accessor :key
    attr_reader :data

    def initialize(key, &block)
      @key = key
      @on_update = nil
      block.call(self) if block
    end

    def on_update(&block)
      @on_update = block
      self
    end

    def push_url
      @push_url ||= BASE_URL.gsub(/:widget_key/, self.key)
    end

    def update(&on_complete)
      request = Gecko::Http.new(self.push_url).post do |req|
        req.body = MultiJson.dump(self.payload)
      end
      request.on_complete do |*args|
        @on_update.call(*args) if @on_update.respond_to?(:call)
        on_complete.call(*args) if on_complete
      end
      request
    end

    def config(&block)
      block.call(self)
      self
    end

    def config!(&block)
      self.config(&block).update
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