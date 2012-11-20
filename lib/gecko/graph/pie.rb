module Gecko
  class Widget
    class Pie < Widget
      include Enumerable

      Item = Struct.new(:value, :label, :color)

      def initialize(*args, &block)
        super
        @items = []
      end

      def each(&block)
        @items.each(&block)
      end

      def reset
        @items.clear
        self
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
        {:item => self.map{|item| self.item_payload(item) }}
      end

      def item_payload(item)
        h = {:value => item.value, :label => item.label}
        h.merge!({:colour => item.color}) if item.color
        h
      end
    end
  end
end