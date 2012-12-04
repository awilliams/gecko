require 'helper'

describe Gecko::Widget::Pie do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => []
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.add(1, 'first', '#cc0000')
      @widget.add(2, 'second', '#ffffff')
      @widget.add(3, 'third')
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => [
            {:value => 1, :label => 'first', :colour => '#cc0000'},
            {:value => 2, :label => 'second', :colour => '#ffffff'},
            {:value => 3, :label => 'third'},
          ]
        }
      )
    end
  end
end