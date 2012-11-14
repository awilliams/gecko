module Gecko
  class Widget
    class NumberSecondaryStat < Widget
      attr_accessor :primary_text, :primary_value, :secondary_text, :secondary_value

      def data_payload
        {:item =>
          [{
           :text => self.primary_text,
           :value => self.primary_value
         }, {
           :text => self.secondary_text,
           :value => self.secondary_value
         }]}
      end
    end
  end
end