# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module MasterFox
      #  `exposed_attributes` is our custom JSONAPI extension to make `attributes` public
      #
      #  @example
      #
      #  # bad
      #  class Foo
      #    exposed_attributes :bar, :baz, something: 'something'
      #  end
      #
      #  # good
      #  class Foo
      #    attribute :bar, public: true, something: 'something'
      #    attribute :baz, public: true, something: 'something'
      #  end
      #
      class ExposedAttributes < RuboCop::Cop::Base
        extend AutoCorrector
        include RuboCop::Masterfox::Support
        include IgnoredNode

        def_node_matcher :on_exposed_attributes, <<~PATTERN
          (send nil? :exposed_attributes (:sym $_)* ...)
        PATTERN

        MSG = 'This method is deprecated. Replace it with: `attribute :%s, public: true`'

        def on_send(node)
          on_exposed_attributes(node) do |*attrs|
            attrs.flatten!
            message = format(MSG, attrs.first)
            offense(node, message, attrs)

            ignore_node(node)
          end
        end

        private

        def offense(node, message, attrs)
          options = prepare_options(node)

          add_offense(node, message:) do |corrector|
            next if part_of_ignored_node?(node)

            corrector.replace(node, fix_attributes(attrs, options))
          end
        end

        def prepare_options(node)
          return if node.arguments.map(&:class).uniq == [RuboCop::AST::SymbolNode]

          node.arguments.last.pairs.map do |pair|
            { pair.children[0].value => to_boolean(pair.children[1]) }
          end.reduce(:merge)
        end

        def fix_attributes(attrs, options)
          if options&.any?
            attrs.map do |attr|
              "attribute :#{attr}, public: true, #{format_options(options)}"
            end.join("\n")
          else
            attrs.map do |attr|
              "attribute :#{attr}, public: true"
            end.join("\n")
          end
        end

        def format_options(options)
          options.map do |k, v|
            # Hacky way to make string interpolation since Ruby strips the
            # Symbol/String from the variable
            case v
            in Symbol
              "#{k}: :#{v}"
            in String
              "#{k}: '#{v}'"
            else
              "#{k}: #{v}"
            end
          end.join(', ')
        end
      end
    end
  end
end
