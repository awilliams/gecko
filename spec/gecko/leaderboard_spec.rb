require 'helper'

describe Gecko::Widget::Leaderboard do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :items => []
        }
      )
    end

    it 'should be currect hash when values assigned' do
      @widget.decimal
      @widget.add("first")
      @widget.add("second", 2)
      @widget.add("third", 3, 3)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :format => :decimal,
          :items => [
            {:label => "first"},
            {:label => "second", :value => 2},
            {:label => "third", :value => 3, :previous_rank => 3}
          ]
        }
      )
    end

    it 'should be correct hash when currency option selected' do
      @widget.currency("USD")
      @widget.add("first")
      @widget.add("second", 2)
      @widget.add("third", 3, 3)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :format => :currency,
          :unit => "USD",
          :items => [
            {:label => "first"},
            {:label => "second", :value => 2},
            {:label => "third", :value => 3, :previous_rank => 3}
          ]
        }
      )
    end

    it 'should be correct hash when percent option selected' do
      @widget.percent
      @widget.add("first")
      @widget.add("second", 2)
      @widget.add("third", 3, 3)
      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {
          :format => :percent,
          :items => [
            {:label => "first"},
            {:label => "second", :value => 2},
            {:label => "third", :value => 3, :previous_rank => 3}
          ]
        }
      )
    end
  end
end
