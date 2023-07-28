# frozen_string_literal: true

RSpec.describe RuboCop::Cop::MasterFox::ExposedHasMany, :config do
  let(:config) { RuboCop::Config.new }

  describe 'registers an offense when using `#exposed_has_many`' do
    it 'public has_many' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_has_many :bar
          ^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedHasMany: This method is deprecated. Replace it with: `has_many :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          has_many :bar, public: true
        end
      RUBY
    end

    it 'keeps any custom options' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_has_many :bar, readonly: true, something: 'else'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedHasMany: This method is deprecated. Replace it with: `has_many :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          has_many :bar, public: true, readonly: true, something: else
        end
      RUBY
    end
  end

  it 'does not register an offense when using `#has_many (public)`' do
    expect_no_offenses(<<~RUBY)
      has_many :bar, public: true
    RUBY
  end
end
