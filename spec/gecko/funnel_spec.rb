require 'helper'

describe Gecko::Widget::Funnel do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :type => :standard,
          :percentage => :show,
          :item => []
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.hide_percentage
      @widget.reverse
      @widget.add(100, 'benjamin')
      @widget.add(1, 'washington')
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :type => :reverse,
          :percentage => :hide,
          :item => [
            {:value => 100, :label => 'benjamin'},
            {:value => 1, :label => 'washington'}
          ]
        }
      )
    end
  end
end