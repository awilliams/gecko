module Gecko
  class Widget
    class Line < Widget
      include Enumerable

      attr_accessor :color, :x_axis, :y_axis

      def initialize(*args, &block)
        super
        @x_axis = []
        @y_axis = []
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

      def add_x_axis(*args)
        @x_axis.push(*args)
      end

      def add_y_axis(*args)
        @y_axis.push(*args)
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
          :item => self.to_a,
          :settings => {
            :axisx => self.x_axis,
            :axisy => self.y_axis,
            :colour => self.color
          }
        }
      end
    end
  end
end
#21296-186a2ce25d6202ed4203ec175bf847db