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
          :x_axis => { :labels => nil, :type => nil },
          :y_axis => { :format => nil, :unit => nil },
          :series => []
        }
      )
    end

    it 'should be correct hash when values assigned' do
      @widget.add([5,6,7])
      @widget.labels = %w(a b c)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :x_axis => { :labels => ['a', 'b', 'c'], :type => nil },
          :y_axis => { :format => nil, :unit => nil },
          :series => [{
            :data => [5, 6, 7]
          }]
        }
      )
    end

    # https://developer.geckoboard.com/#simple-example-13
    it 'should be correct hash when all values assigned' do
      @widget.labels = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
      @widget.add([1.62529, 1.56991], 'GBP -> USD')
      @widget.add([1.23226, 1.15025], 'GBP -> EUR')
      @widget.format = 'currency'
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :x_axis => { :labels => ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], :type => nil },
          :y_axis => { :format => 'currency', :unit => nil },
          :series => [
            {:data => [1.62529, 1.56991], :name => "GBP -> USD"},
            {:data => [1.23226, 1.15025], :name => "GBP -> EUR"}
          ]
        }
      )
    end
  end
end
