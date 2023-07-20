# frozen_string_literal: true

module RuboCop
  module Cop
    module MasterFox
#  `exposed_attributes` is our custom JSONAPI extension to make `attributes` public
      #
      #  @example
      #
      #  # bad
      #  class Foo
      #    exposed_attributes :bar
      #  end
      #
      #  # good
      #  class Foo
      #    attribute :bar, public: true
      #  end
      #
      class ExposedAttributes < RuboCop::Cop::Base
        extend AutoCorrector
        include IgnoredNode

        def_node_matcher :on_exposed_attributes, <<~PATTERN
          (send nil? :exposed_attributes (:sym $_) ...)
        PATTERN

        MSG = 'This method is deprecated. Replace it with: `attribute :%s, public: true`'.freeze

        def on_send(node)
          on_exposed_attributes(node) do |attr|
            message = MSG % [attr]

            add_offense(node, message: message) do |corrector|
              next if part_of_ignored_node?(node)

              corrector.replace(node, "attribute :#{attr}, public: true")
            end

            ignore_node(node)
          end
        end
      end
    end
  end
end
