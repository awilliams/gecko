module Gecko
  class Widget
    class Text < Widget
      include Enumerable

      class Item
        TYPES = {
          :normal => 0,
          :alert => 1,
          :info => 2
        }
        attr_accessor :text
        attr_reader :type

        def initialize(text = nil, type = :normal)
          self.text = text
          self.type = type
        end

        def type=(type)
          @type = if type.kind_of?(Numeric)
            TYPES.values.include?(type) ? type : nil
          else
            TYPES.fetch(type, nil)
          end
          @type or raise ArgumentError, "#{type} is not a valid text type"
        end
      end

      def initialize(*args, &block)
        super
        @items = []
      end

      def reset
        @items.clear
        self
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
          :item => self.map{ |item| {:text => item.text, :type => item.type} }
        }
      end
    end
  end
end