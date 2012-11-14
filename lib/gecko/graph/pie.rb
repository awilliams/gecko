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
        {:item => self.map{|item| {:value => item.value, :label => item.label, :colour => item.color} }}
      end
    end
  end
end