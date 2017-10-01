module Gecko
  class Widget
    class Bar < Widget
      include Enumerable

      attr_accessor :x_axis, :y_axis

      def initialize(*args, &block)
        super
        @x_axis = []
        @y_axis = {}
        @items = []
      end

      def each(&block)
        @items.each(&block)
      end

      def add(*args)
        @items.push(*args)
      end

      def reset
        @items.clear
        self
      end

      def [](index)
        @items[index]
      end

      def []=(index, *args)
        @items[index] = *args
      end

      def items=(array)
        @items = array
      end

      def delete(index)
        @items.delete_at(index)
      end

      def data_payload
        {
          :series => [
            { :data => self.to_a }
          ],
          :x_axis => { :labels => self.x_axis },
          :y_axis => self.y_axis
        }
      end
    end
  end
end
