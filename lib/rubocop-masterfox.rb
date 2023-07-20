# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/masterfox'
require_relative 'rubocop/masterfox/version'
require_relative 'rubocop/masterfox/inject'

RuboCop::Masterfox::Inject.defaults!

require_relative 'rubocop/cop/masterfox_cops'
