# frozen_string_literal: true

RSpec.describe RuboCop::Cop::MasterFox::ExposedHasOne, :config do
  let(:config) { RuboCop::Config.new }

  describe 'registers an offense when using `#exposed_has_one`' do
    it 'public has_many' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_has_one :bar
          ^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedHasOne: This method is deprecated. Replace it with: `has_one :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          has_one :bar, public: true
        end
      RUBY
    end

    it 'keeps any custom options' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_has_one :bar, readonly: true, something: 'else'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedHasOne: This method is deprecated. Replace it with: `has_one :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          has_one :bar, public: true, readonly: true, something: else
        end
      RUBY
    end

    it 'keeps symbol from options' do
      expect_offense(<<~RUBY)
        class Foo
          exposed_has_one :bar, foreign_key: :something
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ MasterFox/ExposedHasOne: This method is deprecated. Replace it with: `has_one :bar, public: true`
        end
      RUBY

      expect_correction(<<~RUBY)
        class Foo
          has_one :bar, public: true, foreign_key: :something
        end
      RUBY
    end
  end

  it 'does not register an offense when using `#has_one (public)`' do
    expect_no_offenses(<<~RUBY)
      has_one :bar, public: true
    RUBY
  end
end
