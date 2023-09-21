# frozen_string_literal: true

RSpec.shared_context 'model_validators' do
  # Filter the errors of a given item to only those of a given attribute.
  # And, if an error_type is given, filter the errors to only those of that type.
  def filter_errors(item_or_its_errors, attribute, error_type = nil)
    errors = item_or_its_errors.is_a?(ActiveModel::Errors) ? item_or_its_errors : item_or_its_errors.errors
    errors.select { |e| e.attribute == attribute && (error_type.nil? || e.type == error_type) }
  end

  alias f filter_errors

  def any_f?(*args)
    f(*args).any?
  end

  alias af any_f?
  alias af? any_f?
end
