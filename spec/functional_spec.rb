require 'helper'

describe Gecko do
  before(:all) do
    Gecko.config.api_push_url = '/v1/send/:widget_key'
  end

  context 'Widget with 2 keys, successful response' do
    before(:each) do
      @widget = Gecko::Widget::Text.new('widget_key1', 'widget_key2')
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        @widget.keys.each do |key|
          stub.post(@widget.push_url(key)) { [200, {}, MultiJson.encode({})] }
        end
      end
      Gecko.config.http_builder do |builder|
        builder.adapter :test, stubs
      end
    end

    describe '#update' do
      it 'should return 2 request objects' do
        update_result = @widget.update
        expect(update_result).to be_a(Array)
        update_result.each do |result|
          expect(result).to be_a(Gecko::Http::Result)
        end
      end
    end
  end
end