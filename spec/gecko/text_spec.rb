require 'helper'

describe Gecko::Widget::Text do
  it_behaves_like "a Gecko::Widget"

  describe described_class::Item do
    describe '#initialize' do
      it 'should raise error if undefined type given' do
        expect{ described_class::Item.new('text', :undefined_type) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#reset' do
    before(:each) do
      @widget = described_class.new('widget_key')
      @widget.add('this is test')
    end
    it 'should clear items' do
      @widget.reset
      expect(@widget.count).to be(0)
    end
  end

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {:item => []}
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.add('this is the text')
      @widget.add('more text', :alert)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {:item => [
          {:text => 'this is the text', :type => described_class::Item::TYPES[:normal]},
          {:text => 'more text', :type => described_class::Item::TYPES[:alert]}
        ]}
      )
    end
  end
end