module Gecko
  class Widget
    class Line < Widget
      include Enumerable

      attr_accessor :series, :labels, :type, :format, :unit

      Serie = Struct.new(:data, :name, :incomplete_from, :type)

      def initialize(*args, &block)
        super
        @x_axis = {}
        @y_axis = {}
        @series = []
      end

      def each(&block)
        @series.each(&block)
      end

      def add(*args)
        @series.push(Serie.new(*args))
      end

      def reset
        @series.clear
        self
      end

      def [](index)
        @series[index]
      end

      def []=(index, *args)
        @series[index] = Serie.new(*args)
      end

      def delete(index)
        @series.delete_at(index)
      end

      def x_axis
        { :labels => labels, :type => type }
      end

      def y_axis
        { :format => format, :unit => unit }
      end

      def data_payload
        {
          :x_axis => x_axis,
          :y_axis => y_axis,
          :series => self.map{ |serie| self.serie_payload(serie) }
        }
      end

      def serie_payload(serie)
        h = { :data => serie.data }
        %w(name incomplete_from type).each do |k|
          h.merge!(k.to_sym => serie.send(k)) if serie.send(k)
        end
        h
      end
    end
  end
end
