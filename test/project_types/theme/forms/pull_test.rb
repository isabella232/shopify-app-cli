# frozen_string_literal: true
require 'project_types/theme/test_helper'

module Theme
  module Forms
    class PullTest < MiniTest::Test
      resp = [200,
              { "themes" =>
               [{ "id" => 2468,
                  "name" => "my_theme" },
                { "id" => 1357,
                  "name" => "your_theme" }] }]
      THEMES = resp[1]['themes'].map { |theme| [theme['name'], theme['id']] }.to_h

      def test_returns_all_defined_attributes_if_valid
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        form = ask
        assert_equal(form.store, 'shop.myshopify.com')
        assert_equal(form.password, 'boop')
        assert_equal(form.themeid, 2468)
        assert_equal(form.name, 'my_theme')
      end

      def test_env_can_be_provided_by_flag
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        form = ask(env: 'test')
        assert_equal(form.env, 'test')
      end

      def test_env_nil_if_not_provided
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        form = ask
        assert_nil(form.env)
      end

      def test_store_can_be_provided_by_flag
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        form = ask(store: 'shop.myshopify.com')
        assert_equal(form.store, 'shop.myshopify.com')
      end

      def test_store_is_prompted
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        CLI::UI::Prompt.expects(:ask)
          .with(@context.message('theme.forms.ask_store'), allow_empty: false)
          .returns('shop.myshopify.com')
        ask(store: nil)
      end

      def test_password_can_be_provided_by_flag
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        form = ask(password: 'boop')
        assert_equal(form.password, 'boop')
      end

      def test_password_is_prompted
        Themekit.expects(:query_themes)
          .with(@context, store: 'shop.myshopify.com', password: 'boop')
          .returns(THEMES)

        CLI::UI::Prompt.expects(:ask).with(@context.message('theme.forms.ask_password'), allow_empty: false)
          .returns('boop')
        ask(password: nil)
      end

      def test_aborts_if_field_empty
        CLI::UI::Prompt.expects(:ask).with(@context.message('theme.forms.ask_store'), allow_empty: false)
          .returns(' ')
        CLI::UI::Prompt.expects(:ask).with(@context.message('theme.forms.ask_password'), allow_empty: false)
          .returns(' ')

        assert_nil(ask(store: nil, password: nil, themeid: nil))
      end

      private

      def ask(password: 'boop', store: 'shop.myshopify.com', themeid: 2468, env: nil)
        Pull.ask(@context,
                 [],
                 password: password,
                 store: store,
                 themeid: themeid,
                 env: env)
      end
    end
  end
end
