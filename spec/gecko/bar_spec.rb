require 'helper'

describe Gecko::Widget::Bar do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :series => [
            { :data => [] }
          ],
          :x_axis => { :labels => [] },
          :y_axis => { }
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.x_axis = [1, 2, 3]
      @widget.y_axis = { :format => 'currency' }
      @widget.add(5,6,7)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :series => [
            { :data => [5, 6, 7] }
          ],
          :x_axis => { :labels => [1, 2, 3] },
          :y_axis => { :format => 'currency' }
        }
      )
    end
  end
end
