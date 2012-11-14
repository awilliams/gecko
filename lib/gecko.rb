module Gecko
  class << self
    def config
      yield self.configurator if block_given?
      self.configurator
    end

    protected

    def configurator
      @configurator ||= Configurator.new
    end
  end
end

require "gecko/version" unless Gecko.const_defined?(:VERSION)
require "gecko/configurator"
require "gecko/http"
require "gecko/widget"