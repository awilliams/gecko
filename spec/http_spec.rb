require 'helper'

describe Gecko::Http do
  def stub_post(url, request_body = {}, &response)
    stub = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post(url, MultiJson.encode(request_body), &response)
    end
    Gecko::Http.new do |builder|
      builder.adapter :test, stub
    end
  end

  describe '#initialize' do
    after(:all) do
      # reset config
      Gecko.config.http_builder {  }
    end

    it 'should yield connection builder' do
      expect{ |p| described_class.new(&p) }.to yield_with_args(Faraday::Connection)
    end

    it 'should use Gecko.config.connection_builder' do
      Gecko.config.http_builder { |c|
        expect(c).to be_a(Faraday::Connection)
      }
      expect(Gecko.config.connection_builder).to receive(:call).and_call_original
      described_class.new
    end
  end

  describe '#post' do
    it 'returns string if invalid json given' do
      http = stub_post('/test', {:test => true}) { [200, {}, 'caca}'] }
      expect(http.post('/test', {:test => true}).response_body).to eq("caca}") 
    end

    it 'should return a Result object' do
      http = stub_post('/test', {:test => true}) { [200, {}, MultiJson.encode({})] }
      expect(http.post('/test', {:test => true})).to be_a(described_class::Result)
    end

    it 'should yield a Faraday::Request instance' do
      http = stub_post('/test', {:test => true}) { [200, {}, MultiJson.encode({})] }
      expect { |p| http.post('/test', {:test => true}, &p) }.to yield_with_args(Faraday::Request)
    end

    describe described_class::Result do
      context 'success response' do
        before(:each) do
          @http = stub_post('/test', {:test => true}) { [200, {}, MultiJson.encode({:success => true, :other_key => {:nested_key => 1234}})] }
          @response = @http.post('/test', {:test => true})
        end

        it '#response_body should be a converted from JSON' do
          expect(@response.response_body).to eq({:success => true, :other_key => {:nested_key => 1234}})
        end

        it '#http_200? should be true' do
          expect(@response.http_200?).to be true
        end

        it '#error? should be false' do
          expect(@response.error?).to be false
        end

        it '#success? should be true' do
          expect(@response.success?).to be true
        end

        it '#fetch should work with nested keys' do
          expect(@response.fetch(:other_key, :nested_key)).to eq(1234)
        end

        it '#fetch should return nil if key does not exist' do
          expect(@response.fetch(:weird_key, :nested_key)).to be_nil
        end

        it '#error should return an Error instance' do
          expect(@response.error).to be_a(described_class::Error)
        end

        it '#error should be empty' do
          error = @response.error
          expect(error.text).to be_nil
          expect(error.status).to eq(200)
        end

        it '#on_complete should call block with correct params' do
          expect{ |p| @response.on_complete(&p) }.to yield_with_args(true, described_class)
        end
      end

      context 'error response' do
        before(:each) do
          @http = stub_post('/test', {:test => true}) { [400, {}, MultiJson.encode({:success => false, :error => {:nested_key => 1234}})] }
          @response = @http.post('/test', {:test => true})
        end

        it '#response_body should be a converted from JSON' do
          expect(@response.response_body).to eq({:success => false, :error => {:nested_key => 1234}})
        end

        it '#http_200? should be true' do
          expect(@response.http_200?).to be false
        end

        it '#error? should be false' do
          expect(@response.error?).to be true
        end

        it '#success? should be true' do
          expect(@response.success?).to be false
        end

        it '#fetch should work with nested keys' do
          expect(@response.fetch(:error, :nested_key)).to eq(1234)
        end

        it '#fetch should return nil if key does not exist' do
          expect(@response.fetch(:weird_key, :nested_key)).to be_nil
        end

        it '#error should return an Error instance' do
          expect(@response.error).to be_a(described_class::Error)
        end

        it '#error should be populated' do
          error = @response.error
          expect(error.text).to eq({:nested_key => 1234})
          expect(error.status).to eq(400)
        end

        it '#on_complete should call block with correct params' do
          expect { |p| @response.on_complete(&p) }.to yield_with_args(false, described_class)
        end
      end
    end
  end

end
