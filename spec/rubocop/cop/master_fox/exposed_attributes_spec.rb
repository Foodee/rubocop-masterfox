# frozen_string_literal: true

RSpec.describe RuboCop::Cop::MasterFox::ExposedAttributes, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#exposed_attributes`' do
    expect_offense(<<~RUBY)
      exposed_attributes :bar
      ^^^^^^^^^^^^^^^^^^^^^^^ This method is deprecated. Replace it with: `attribute :bar, public: true`.
    RUBY

    expect_correction(<<~RUBY)
      attribute :bar, public: true
    RUBY
  end

  it 'does not register an offense when using `#attribute (public)`' do
    expect_no_offenses(<<~RUBY)
      class FooTest < Minitest::Test
        attribute :bar, public: true
      end
    RUBY
  end
end
