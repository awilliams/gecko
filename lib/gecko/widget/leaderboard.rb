module Gecko
  class Widget
    class Leaderboard < Widget
      include Enumerable

      Item = Struct.new(:label, :value, :previous_rank)

      attr_reader :format, :unit

      def initialize(*args, &block)
        super
        @items = []
      end

      def reset
        @items.clear
        self
      end

      def decimal
        @format = :decimal
      end

      def percent
        @format = :percent
      end

      def currency(currency_code)
        @format = :currency
        @unit = currency_code
      end

      def each(&block)
        @items.each(&block)
      end

      def add(*args)
        @items.push(Item.new(*args))
      end

      def [](index)
        @items[index]
      end

      def []=(index, *args)
        @items[index] = Item.new(*args)
      end

      def delete(index)
        @items.delete_at(index)
      end

      def data_payload
        h = {}
        h.merge!({ :format => self.format }) if @format
        h.merge!({ :unit => self.unit }) if @unit
        h.merge!({ :items => self.map{|item| self.item_payload(item) }})
      end

      def item_payload(item)
        h = {:label => item.label}
        h.merge!({:value => item.value}) if item.value
        h.merge!({:previous_rank => item.previous_rank}) if item.previous_rank
        h
      end
    end
  end
end
