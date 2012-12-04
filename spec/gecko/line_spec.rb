require 'helper'

describe Gecko::Widget::Line do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => [],
          :settings => {
            :axisx => [],
            :axisy => [],
            :colour => nil
          }
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.x_axis = [1, 2, 3]
      @widget.y_axis = %w(a b c)
      @widget.add(5,6,7)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :item => [5, 6, 7],
          :settings => {
            :axisx => [1, 2, 3],
            :axisy => ['a', 'b', 'c'],
            :colour => nil
          }
        }
      )
    end
  end
end