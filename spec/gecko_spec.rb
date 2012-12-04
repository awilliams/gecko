require 'helper'

describe Gecko do
  describe '#config' do
    it 'should return a config object' do
      expect(described_class.config).to be_a described_class::Configurator
    end

    it 'should yield config object' do
      expect{ |p| described_class.config(&p) }.to yield_with_args(described_class::Configurator)
    end

    it 'should allow setting/getting #api_key' do
      api_key = 'abc1234'
      described_class.config.api_key = api_key
      described_class.config.api_key.should eql api_key
    end

    it '#http_builder by default should not respond to call' do
      described_class.config.http_builder # nil out any previous values
      expect(described_class.config.connection_builder.respond_to?(:call)).to be_false
    end

    it '#http_builder should allow setting via block' do
      proc = Proc.new { 1 }
      described_class.config.http_builder(&proc)
      expect(described_class.config.connection_builder.respond_to?(:call)).to be_true
      expect(described_class.config.connection_builder).to be proc
    end
  end
end