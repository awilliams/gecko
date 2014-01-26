module Gecko
  class Widget
    class NumberSecondaryStat < Widget
      attr_accessor :primary_text, :primary_value, :primary_prefix, :secondary_text, :secondary_value, :secondary_prefix, :absolute, :type

      def data_payload
        {:item =>
          [{
           :text => self.primary_text,
           :value => self.primary_value,
           :prefix => self.primary_prefix
         }, {
           :text => self.secondary_text,
           :value => self.secondary_value,
           :prefix => self.secondary_prefix
         }],
         :absolute => self.absolute,
         :type => self.type
        }
      end
    end
  end
end
