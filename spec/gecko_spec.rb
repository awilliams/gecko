require 'helper'

describe Gecko do
  describe '#config' do
    it 'should return a config object' do
      expect(Gecko.config).to be_a Gecko::Configurator
    end

    it 'should yield config object' do
      expect{ |p| Gecko.config(&p) }.to yield_with_args(Gecko::Configurator)
    end

    it 'should allow setting/getting #api_key' do
      api_key = 'abc1234'
      Gecko.config.api_key = api_key
      Gecko.config.api_key.should eql api_key
    end

    it '#http_builder by default should not respond to call' do
      expect(Gecko.config.connection_builder.respond_to?(:call)).to be_false
    end

    it '#http_builder should allow setting via block' do
      proc = Proc.new { 1 }
      Gecko.config.http_builder(&proc)
      expect(Gecko.config.connection_builder.respond_to?(:call)).to be_true
      expect(Gecko.config.connection_builder).to be proc
    end
  end
end