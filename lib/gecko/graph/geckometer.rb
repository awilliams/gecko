module Gecko
  class Widget
    class Geckometer < Widget
      EndPoint = Struct.new(:value, :text)

      attr_accessor :value
      attr_reader :min, :max
      def initialize(*args, &block)
        super
        @min, @max = EndPoint.new, EndPoint.new
      end

      def min_value=(value)
        self.min.value = value
      end

      def min_text=(text)
        self.min.text = text
      end

      def max_value=(value)
        self.max.value = value
      end

      def max_text=(text)
        self.max.text = text
      end

      def data_payload
        {
          :item => self.value,
          :min => {:value => self.min.value, :text => self.min.text},
          :max => {:value => self.max.value, :text => self.max.text}
        }
      end

    end
  end
end

#21296-2d1ec38771f67866d32439bc8b107caa