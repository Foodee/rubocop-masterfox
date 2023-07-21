# frozen_string_literal: true

RSpec.describe RuboCop::Cop::MasterFox::ExposedAttribute, :config do
  let(:config) { RuboCop::Config.new }

  describe 'registers an offense when using `#exposed_attribute`' do
    it 'keeps one option' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_attribute :bar, readonly: true
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedAttribute: This method is deprecated. Replace it with: `attribute :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          attribute :bar, public: true, readonly: true
        end
      RUBY
    end

    it 'keeps any options' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_attribute :bar, readonly: true, something: 'else'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedAttribute: This method is deprecated. Replace it with: `attribute :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          attribute :bar, public: true, readonly: true, something: else
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
