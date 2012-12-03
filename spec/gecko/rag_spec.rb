require 'helper'

shared_examples "a RAG" do
  it_behaves_like "a Gecko::Widget"

  describe '#payload' do
    before(:each) do
      @widget = described_class.new('widget_key')
    end

    it 'should be empty by default' do
      expect(@widget.payload).to be_a_valid_payload(
       TEST_API_KEY,
       {:item => [
         {:value => nil, :text => nil},
         {:value => nil, :text => nil},
         {:value => nil, :text => nil}
       ]}
     )
    end

    it 'should be correct hash when values assigned' do
      @widget.green_text = 'green text'
      @widget.green_value = 1
      @widget.amber_text = 'amber text'
      @widget.amber_value = 2
      @widget.red_text = 'red text'
      @widget.red_value = 3

      expect(@widget.payload).to be_a_valid_payload(
        TEST_API_KEY,
        {:item => [
          {:value => 3, :text => 'red text'},
          {:value => 2, :text => 'amber text'},
          {:value => 1, :text => 'green text'},
        ]}
      )
    end
  end
end

describe Gecko::Widget::Rag do
  it_behaves_like "a RAG"
end

describe Gecko::Widget::RagColumns do
  it_behaves_like "a RAG"
end