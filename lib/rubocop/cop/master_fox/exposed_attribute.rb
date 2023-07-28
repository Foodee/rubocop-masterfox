# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module MasterFox
      #  `exposed_attribute` is our custom JSONAPI extension to make `attributes` public
      #
      #  @example
      #
      #  # bad
      #  class Foo
      #    exposed_attribute :bar, something: 'something'
      #  end
      #
      #  # good
      #  class Foo
      #    attribute :bar, public: true, something: 'something'
      #  end
      #
      class ExposedAttribute < RuboCop::Cop::Base
        extend AutoCorrector
        include RuboCop::Masterfox::Support
        include IgnoredNode

        def_node_matcher :on_exposed_attributes, <<~PATTERN
          (send nil? :exposed_attribute (:sym $_) ...)
        PATTERN

        MSG = 'This method is deprecated. Replace it with: `attribute :%s, public: true`'

        def on_send(node)
          on_exposed_attributes(node) do |attr|
            message = format(MSG, attr)
            offense(node, message, attr)

            ignore_node(node)
          end
        end

        private

        def offense(node, message, attr)
          options = prepare_options(node)

          add_offense(node, message:) do |corrector|
            next if part_of_ignored_node?(node)

            corrector.replace(node, fix_attributes(attr, options))
          end
        end

        def prepare_options(node)
          node.arguments.last.pairs.map do |pair|
            { pair.children[0].value => to_boolean(pair.children[1]) }
          end.reduce(:merge)
        end

        def fix_attributes(attr, options)
          if options.any?
            "attribute :#{attr}, public: true, #{options.map { |k, v| "#{k}: #{v}" }.join(', ')}"
          else
            "attribute :#{attr}, public: true"
          end
        end
      end
    end
  end
end
