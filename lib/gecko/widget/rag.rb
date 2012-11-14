module Gecko
  class Widget
    class Rag < Widget
      attr_accessor :green_text, :green_value, :amber_text, :amber_value, :red_text, :red_value

      def data_payload
        {:item =>
          [{
          :text => self.red_text,
          :value => self.red_value
         }, {
          :text => self.amber_text,
          :value => self.amber_value
         }, {
          :text => self.green_text,
          :value => self.green_value
         }]}
      end
    end
  end
end