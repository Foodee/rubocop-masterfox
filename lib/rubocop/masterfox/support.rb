# frozen_string_literal: true

module RuboCop
  module Masterfox
    # Support Cops
    module Support
      # Gross hack to typecast
      def to_boolean(sym)
        if false?(sym.type.to_s)
          false
        elsif true?(sym.type.to_s)
          true
        else
          sym.value
        end
      end

      def false?(obj)
        obj == 'false'
      end

      def true?(obj)
        obj == 'true'
      end
    end
  end
end
