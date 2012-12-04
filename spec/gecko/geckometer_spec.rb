require 'helper'

describe Gecko::Widget::Geckometer do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => nil,
          :min => {:value => nil, :text => nil},
          :max => {:value => nil, :text => nil}
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.min_value = 0
      @widget.max_value = 100
      @widget.min_text = 'min'
      @widget.max_text = 'max'
      @widget.value = 50
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => 50,
          :min => {:value => 0, :text => 'min'},
          :max => {:value => 100, :text => 'max'}
        }
      )
    end
  end
end