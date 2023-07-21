# frozen_string_literal: true

RSpec.describe RuboCop::Cop::MasterFox::ExposedAttributes, :config do
  let(:config) { RuboCop::Config.new }

  describe 'registers an offense when using `#exposed_attributes`' do
    it 'successfully splits attributes into their own lines' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_attributes :bar,
          ^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedAttributes: This method is deprecated. Replace it with: `attribute :bar, public: true`
                            :foo,
                            :baz
        end
      RUBY

      expect_correction(<<~RUBY)
      class Foo
        attribute :bar, public: true
      attribute :foo, public: true
      attribute :baz, public: true
      end
      RUBY
    end

    it 'carries options over when autocorrecting' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_attributes :bar,
          ^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedAttributes: This method is deprecated. Replace it with: `attribute :bar, public: true`
                            :foo,
                            :baz,
                            readonly: true
        end
      RUBY

      expect_correction(<<~RUBY)
      class Foo
        attribute :bar, public: true, readonly: true
      attribute :foo, public: true, readonly: true
      attribute :baz, public: true, readonly: true
      end
      RUBY
    end
  end

  it 'does not register an offense when using `#attribute (public)`' do
    expect_no_offenses(<<~RUBY)
      attribute :bar, public: true
    RUBY
  end
end
