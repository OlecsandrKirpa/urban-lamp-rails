# frozen_string_literal: true

return

require 'rails_helper'

RSpec.describe ActiveInteractionMatchersExample, type: :interaction do
  context 'just :have_input' do
    it do
      is_expected.to have_input(:mandatory_string)
    end

    it do
      is_expected.not_to have_input(:not_existing_input)
    end
  end

  context 'mandatory inputs' do
    it do
      is_expected.to have_input(:mandatory_string).mandatory
    end

    it do
      is_expected.not_to have_input(:mandatory_string).optional
    end
  end

  context 'with or without default values' do
    it do
      is_expected.to have_input(:mandatory_string).without_default_value
    end

    it do
      is_expected.not_to have_input(:mandatory_string).with_default_value
    end
  end

  context 'optional inputs' do
    it do
      is_expected.to have_input(:optional_string).optional
    end

    it do
      is_expected.not_to have_input(:optional_string).mandatory
    end
  end

  context 'default values' do
    it do
      is_expected.to have_input(:optional_string).with_default_value('default value')
    end

    it do
      is_expected.to have_input(:optional_integer).with_default_value(1)
    end

    it do
      is_expected.not_to have_input(:mandatory_integer).with_default_value(2)
    end
  end

  context 'input types' do
    it do
      is_expected.to have_input(:optional_string).of_type(String)
    end

    it do
      is_expected.to have_input(:optional_string).of_type('string')
    end

    it do
      is_expected.to have_input(:optional_string).of_type(:string)
    end

    it do
      is_expected.to have_input(:optional_string).of_type(:String)
    end

    it do
      is_expected.to have_input(:optional_string).of_type('String')
    end

    it do
      is_expected.not_to have_input(:optional_string).of_type('InvalidString')
    end
  end
end
