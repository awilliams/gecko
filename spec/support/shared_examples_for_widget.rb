require 'helper'

TEST_API_KEY = 'gecko.rb-api_key'
shared_examples 'a Gecko::Widget' do
  before(:all) do
    Gecko.config do |c|
      c.api_key = TEST_API_KEY
    end
  end

  describe '#initialize' do
    it 'should receive a list of keys' do
      widget = described_class.new('widget_key_A', 'widget_key_B')
      expect(widget.keys).to eq(['widget_key_A', 'widget_key_B'])
    end

    it 'should receive an array' do
      widget = described_class.new(['widget_key_A', 'widget_key_B'])
      expect(widget.keys).to eq(['widget_key_A', 'widget_key_B'])
    end

    it 'should yield itself to a block' do
      expect { |p| described_class.new('widget_key', &p) }.to yield_with_args(described_class)
    end

    it 'should raise error if no keys given' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

  describe '#keys=' do
    before(:each) do
      @widget = described_class.new('key')
    end
    it 'should receive a key' do
      @widget.keys = 'widget_key_A'
      expect(@widget.keys).to eq(['widget_key_A'])
    end

    it 'should receive a list of keys' do
      @widget.keys = 'widget_key_A', 'widget_key_B'
      expect(@widget.keys).to eq(['widget_key_A', 'widget_key_B'])
    end

    it 'should receive an array of keys' do
      @widget.keys = ['widget_key_A', 'widget_key_B']
      expect(@widget.keys).to eq(['widget_key_A', 'widget_key_B'])
    end
  end

  describe '#keys' do
    it 'should be an array' do
      widget = described_class.new('widget_key_1234')
      expect(widget.keys).to be_kind_of(Array)
    end
  end

  describe '#config' do
    it 'should yield self' do
      widget = described_class.new('widget_key_1234')
      expect { |p| widget.config(&p) }.to yield_with_args(widget)
    end
  end
end