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
            options = unless node.arguments.map(&:class).uniq == [RuboCop::AST::SymbolNode]
              node.arguments.last.pairs.map do |pair|
                { pair.children[0].value => to_boolean(pair.children[1]) }
              end.reduce(:merge)
            end

            add_offense(node, message: message) do |corrector|
              next if part_of_ignored_node?(node)

              corrector.replace(node, fix_attributes(attrs, options))
            end

            ignore_node(node)
          end
        end

        private

        def fix_attributes(attrs, options)
          if options && options.any?
            attrs.map do |attr|
              "attribute :#{attr}, public: true, #{options.map {|k,v| "#{k}: #{v}"}.join(', ')}"
            end.join("\n")
          else
            attrs.map do |attr|
              "attribute :#{attr}, public: true"
            end.join("\n")
          end
        end
      end
    end
  end
end
