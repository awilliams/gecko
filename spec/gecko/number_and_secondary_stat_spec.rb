require 'helper'

describe Gecko::Widget::NumberSecondaryStat do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {:item => [{:value => nil, :text => nil}, {:value => nil, :text => nil}]}
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.primary_text = 'text A'
      @widget.primary_value = 1
      @widget.secondary_text = 'text B'
      @widget.secondary_value = 2
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {:item => [{:value => 1, :text => 'text A'}, {:value => 2, :text => 'text B'}]}
      )
    end
  end
end