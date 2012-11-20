module Gecko
  class Widget
    class Funnel < Widget
      include Enumerable

      Item = Struct.new(:value, :label)

      attr_reader :reverse

      def initialize(*args, &block)
        super
        self.standard
        self.show_percentage
        @items = []
      end

      def reset
        @items.clear
        self
      end

      def standard
        @reverse = :standard
      end

      def reverse
        @reverse = :reverse
      end

      def show_percentage
        @percentage = :show
      end

      def hide_percentage
        @percentage = :hide
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
        {
          :type => @reverse,
          :percentage => @percentage,
          :item => self.map{|item| {:value => item.value, :label => item.label} }
        }
      end
    end
  end
end