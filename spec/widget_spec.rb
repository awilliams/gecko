require 'helper'

describe Gecko::Widget do
  before(:all) do
    Gecko.config do |c|
      c.api_push_url = '/v1/send/:widget_key'
      c.api_key = TEST_API_KEY
    end
  end

  def create_widget(*keys, &response)
    @widget = described_class.new(*keys)
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      @widget.keys.each do |key|
        stub.post(@widget.push_url(key), MultiJson.encode(@widget.payload), &response)
      end
    end
    Gecko.config.http_builder do |builder|
      builder.adapter :test, stubs
    end
  end

  context 'Widget with 1 key, successful response' do
    before(:each) do
      create_widget('widget_key1') do
        [200, {}, MultiJson.encode({:success => true})]
      end
    end

    describe '#update' do
      it 'should return 1 request objects' do
        update_result = @widget.update
        expect(update_result).to be_a(Array)
        expect(update_result).to have(1).items
        update_result.each do |result|
          expect(result).to be_a(Gecko::Http::Result)
        end
      end

      it 'should evoke callback passed to #update' do
        callback = MockBlock.new
        callback.should_receive(:call).once.with do |success, result, key|
          expect(success).to be_true
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to eq('widget_key1')
        end
        @widget.update(&callback)
      end

      it 'should evoke callback passed to #on_update' do
        callback = MockBlock.new
        callback.should_receive(:call).once.with do |success, result, key|
          expect(success).to be_true
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to eq('widget_key1')
        end
        @widget.on_update(&callback)
        @widget.update
      end

      context 'response object' do
        let(:http_response) { @widget.update.first }

        it 'should have no errors' do
          expect(http_response.error?).to be_false
        end
      end

    end
  end

  context 'Widget with 2 keys, successful response' do
    before(:each) do
      create_widget('widget_key1', 'widget_key2') do
        [200, {}, MultiJson.encode({:success => true})]
      end
    end

    describe '#update' do
      it 'should return 2 request objects' do
        update_result = @widget.update
        expect(update_result).to be_a(Array)
        expect(update_result).to have(2).items
        update_result.each do |result|
          expect(result).to be_a(Gecko::Http::Result)
        end
      end

      it 'should evoke callback passed to #update' do
        callback = MockBlock.new
        callback.should_receive(:call).twice.with do |success, result, key|
          expect(success).to be_true
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to match(/widget_key[1|2]/)
        end
        @widget.update(&callback)
      end

      it 'should evoke callback passed to #on_update' do
        callback = MockBlock.new
        callback.should_receive(:call).twice.with do |success, result, key|
          expect(success).to be_true
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to match(/widget_key[1|2]/)
        end
        @widget.on_update(&callback)
        @widget.update
      end

      context 'response objects' do
        let(:http_responses) { @widget.update }

        it 'should have no errors' do
          http_responses.each do |http_response|
            expect(http_response.error?).to be_false
          end
        end
      end
    end
  end

  context 'Widget with 2 keys, errors response' do
    before(:each) do
      create_widget('widget_key1', 'widget_key2') do
        [200, {}, MultiJson.encode({:success => false, :error => 'Push operation failed due to an unknown reason. Please try again!'})]
      end
    end

    describe '#update' do
      it 'should return 2 request objects' do
        update_result = @widget.update
        expect(update_result).to be_a(Array)
        expect(update_result).to have(2).items
        update_result.each do |result|
          expect(result).to be_a(Gecko::Http::Result)
        end
      end

      it 'should evoke callback passed to #update' do
        callback = MockBlock.new
        callback.should_receive(:call).twice.with do |success, result, key|
          expect(success).to be_false
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to match(/widget_key[1|2]/)
        end
        @widget.update(&callback)
      end

      it 'should evoke callback passed to #on_update' do
        callback = MockBlock.new
        callback.should_receive(:call).twice.with do |success, result, key|
          expect(success).to be_false
          expect(result).to be_a(Gecko::Http::Result)
          expect(key).to match(/widget_key[1|2]/)
        end
        @widget.on_update(&callback)
        @widget.update
      end

      context 'response objects' do
        let(:http_responses) { @widget.update }

        it 'should have errors' do
          http_responses.each do |http_response|
            expect(http_response.error?).to be_true
            expect(http_response.error.to_s).to eq('Push operation failed due to an unknown reason. Please try again!')
          end
        end
      end
    end
  end
end